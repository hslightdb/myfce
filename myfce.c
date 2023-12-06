
#include<stdint.h>
#include "postgres.h"
#include "funcapi.h"
#include "utils/builtins.h"
#include "lib/stringinfo.h"
#include "fmgr.h"
#include "utils/formatting.h"
#include "utils/numeric.h"
#include "utils/lsyscache.h"
#include "utils/timestamp.h"
#include "mb/pg_wchar.h"
#include "utils/guc.h"
#include "utils/lt_guc.h"
#include "utils/date.h"
#include "utils/datetime.h"


#ifdef HAVE_LIBZ
#include <zlib.h>
#endif

#define int4store(T,A)       do { *((char *)(T))=(char) ((A));\
                                  *(((char *)(T))+1)=(char) (((A) >> 8));\
                                  *(((char *)(T))+2)=(char) (((A) >> 16));\
                                  *(((char *)(T))+3)=(char) (((A) >> 24));\
                             } while(0)

#define uint4korr(A)	(uint32) (((uint32) ((unsigned char) (A)[0])) +\
				  		(((uint32) ((unsigned char) (A)[1])) << 8) +\
				  		(((uint32) ((unsigned char) (A)[2])) << 16) +\
				  		(((uint32) ((unsigned char) (A)[3])) << 24))

#define BLOB_HEADER 4

PG_MODULE_MAGIC;

static StringInfo
makeStringAggState(FunctionCallInfo fcinfo)
{
	StringInfo	state;
	MemoryContext aggcontext;
	MemoryContext oldcontext;

	if (!AggCheckCallContext(fcinfo, &aggcontext))
	{
		/* cannot be called directly because of internal-type argument */
		elog(ERROR, "group_concat_transfn called in non-aggregate context");
	}

	/*
	 * Create state in aggregate context.  It'll stay there across subsequent
	 * calls.
	 */
	oldcontext = MemoryContextSwitchTo(aggcontext);
	state = makeStringInfo();
	MemoryContextSwitchTo(oldcontext);

	return state;
}
static void
appendStringInfoText(StringInfo str, const text *t)
{
	appendBinaryStringInfo(str, VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t));
}


PG_FUNCTION_INFO_V1(myfce_group_concat_transfn);
PG_FUNCTION_INFO_V1(myfce_group_concat_transfn_bigint);
PG_FUNCTION_INFO_V1(myfce_group_concat_transfn_float8);
PG_FUNCTION_INFO_V1(myfce_group_concat_transfn_float4);
PG_FUNCTION_INFO_V1(myfce_group_concat_transfn_numeric);
PG_FUNCTION_INFO_V1(myfce_group_concat_finalfn);
PG_FUNCTION_INFO_V1(myfce_find_in_set);
PG_FUNCTION_INFO_V1(myfce_date_format);
PG_FUNCTION_INFO_V1(myfce_date_format_timestamptz);
PG_FUNCTION_INFO_V1(myfce_zlib_compress);
PG_FUNCTION_INFO_V1(myfce_zlib_decompress);
PG_FUNCTION_INFO_V1(myfce_plvstr_instr2);
PG_FUNCTION_INFO_V1(myfce_str_to_date);		// return datetime
PG_FUNCTION_INFO_V1(myfce_str_to_date2);    // return date
PG_FUNCTION_INFO_V1(myfce_str_to_date3);    // return time


PG_FUNCTION_INFO_V1(mysql_substr2);
PG_FUNCTION_INFO_V1(mysql_substr3);

PG_FUNCTION_INFO_V1(myfce_sysdate_0);
//PG_FUNCTION_INFO_V1(myfce_sysdate_1);


#define PARAMETER_ERROR(detail) \
	ereport(ERROR, \
		(errcode(ERRCODE_INVALID_PARAMETER_VALUE), \
		 errmsg("invalid parameter"), \
		 errdetail(detail)));

#ifndef _pg_mblen
#define _pg_mblen	pg_mblen
#endif

int my_mb_strlen(text *str, char **sizes, int **positions);
static int my_instr_mb(text *txt, text *pattern, int start, int nth);
int my_instr(text *txt, text *pattern, int start, int nth);


Datum
myfce_group_concat_transfn(PG_FUNCTION_ARGS)
{
	StringInfo	state;

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	/* Append the value unless null. */
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		appendStringInfoText(state, PG_GETARG_TEXT_PP(2));	/* value */
	}

	/*
	 * The transition type for string_agg() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 */
	PG_RETURN_POINTER(state);
}


Datum
myfce_group_concat_transfn_bigint(PG_FUNCTION_ARGS)
{
	int64		arg0;
	StringInfo	state;

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	/* Append the value unless null. */
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg0 = PG_GETARG_INT64(2);
		appendStringInfo(state, INT64_FORMAT, arg0);
	}

	/*
	 * The transition type for string_agg() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 */
	PG_RETURN_POINTER(state);
}

Datum
myfce_group_concat_transfn_float8(PG_FUNCTION_ARGS)
{
	double		arg2;
	StringInfo	state;

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	/* Append the value unless null. */
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg2 = PG_GETARG_FLOAT8(2);
		appendStringInfoString(state, DatumGetCString(DirectFunctionCall1(float8out, Float8GetDatum(arg2))));
	}

	/*
	 * The transition type for string_agg() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 */
	PG_RETURN_POINTER(state);
}

Datum
myfce_group_concat_transfn_float4(PG_FUNCTION_ARGS)
{
	float	arg2;
	StringInfo	state;

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	/* Append the value unless null. */
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg2 = PG_GETARG_FLOAT4(2);
		appendStringInfoString(state, DatumGetCString(DirectFunctionCall1(float4out, Float4GetDatum(arg2))));
	}

	/*
	 * The transition type for string_agg() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 */
	PG_RETURN_POINTER(state);
}

Datum
myfce_group_concat_transfn_numeric(PG_FUNCTION_ARGS)
{
	Numeric		arg2;
	StringInfo	state;

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	/* Append the value unless null. */
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg2 = PG_GETARG_NUMERIC(2);
		appendStringInfoString(state, DatumGetCString(DirectFunctionCall1(numeric_out, NumericGetDatum(arg2))));
	}

	/*
	 * The transition type for string_agg() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 */
	PG_RETURN_POINTER(state);
}


Datum
myfce_group_concat_finalfn(PG_FUNCTION_ARGS)
{
	StringInfo	state;

	/* cannot be called directly because of internal-type argument */
	Assert(AggCheckCallContext(fcinfo, NULL));

	state = PG_ARGISNULL(0) ? NULL : (StringInfo) PG_GETARG_POINTER(0);

	if (state != NULL)
		PG_RETURN_TEXT_P(cstring_to_text_with_len(state->data, state->len));
	else
		PG_RETURN_NULL();
}

Datum
myfce_find_in_set(PG_FUNCTION_ARGS)
{
	int32_t result=0;
	FmgrInfo   *foutcache;

	char *ret;
	int i;
	StringInfoData arg0;
	StringInfoData arg1;
	initStringInfo(&arg0);
	initStringInfo(&arg1);

	if(fcinfo->flinfo->fn_extra == NULL)
	{
		Oid			valtype;
		Oid			typOutput;
		bool		typIsVarlena;
		foutcache = (FmgrInfo *) MemoryContextAlloc(fcinfo->flinfo->fn_mcxt,sizeof(FmgrInfo));
		valtype = get_fn_expr_argtype(fcinfo->flinfo, 0);
		if (!OidIsValid(valtype))
			elog(ERROR, "could not determine data type of find_in_set() input");

		getTypeOutputInfo(valtype, &typOutput, &typIsVarlena);
		fmgr_info_cxt(typOutput, foutcache, fcinfo->flinfo->fn_mcxt);
		fcinfo->flinfo->fn_extra = foutcache;
	}
	else
	{
		foutcache = fcinfo->flinfo->fn_extra;
	}
	
	appendStringInfoString(&arg0,",");
	if(get_fn_expr_argtype(fcinfo->flinfo, 0) == BPCHAROID)
	{
		char * p = OutputFunctionCall(foutcache, PG_GETARG_DATUM(0));
		int len =strlen(p);
		for(int i=len-1;i>=0;i--)
		{
			if(p[i] == ' ')
			{
				len--;
			}
			else
			{
				break;
			}
		}
		appendBinaryStringInfo(&arg0,
							   p,len);
	}
	else
	{
		appendStringInfoString(&arg0,
							   OutputFunctionCall(foutcache, PG_GETARG_DATUM(0)));
	}

	appendStringInfoString(&arg0,",");

	appendStringInfoString(&arg1,",");
	appendStringInfoText(&arg1, PG_GETARG_TEXT_PP(1));
	appendStringInfoString(&arg1,",");

	//Returns 0 if arg0 contains a comma,
	for ( i=1;i<arg0.len-1;i++)
	{
		if(arg0.data[i] == ',')
		{
			PG_RETURN_INT32(0);
		}
	}

	// find  sub string  of ",arg1,"
	ret = strstr(arg1.data, arg0.data);
	if(!ret)
	{
		PG_RETURN_INT32(0);
	}
	//caculate count of ','
	for(int i=0;i<= ret - arg1.data;i++)
	{
		if(arg1.data[i]  == ',')
		{
			result++;
		}
	}

	PG_RETURN_INT32(result);
}

static void
parse_date_time_format(const char *format,size_t format_length,StringInfoData *str_fmat)
{

	const char *ptr = format;
	const char *end = ptr+format_length;

	for (; ptr != end; ptr++)
	{
		if (*ptr == '%' && ptr+1 != end)
		{
			switch (*++ptr)
			{
				case 'a':
					appendStringInfoString(str_fmat,"Dy");
					break;
				case 'b':
					appendStringInfoString(str_fmat,"Mon");
					break;
				case 'y':
					appendStringInfoString(str_fmat,"yy");
					break;
				case 'Y':
					appendStringInfoString(str_fmat,"yyyy");
					break;
				case 'c':
					appendStringInfoString(str_fmat,"FMMM");
					break;
				case 'm':
					appendStringInfoString(str_fmat,"MM");
					break;
				case 'M':
					appendStringInfoString(str_fmat,"FMMonth");
					break;
				case 'd':
					appendStringInfoString(str_fmat,"DD");
					break;
				case 'D':
					appendStringInfoString(str_fmat,"FMDDth");
					break;
				case 'e':
					appendStringInfoString(str_fmat,"FMDD");
					break;
				case 'h':
				case 'I':
					appendStringInfoString(str_fmat,"hh");
					break;
				case 'l':
					appendStringInfoString(str_fmat,"FMhh");
					break;
				case 'k':
					appendStringInfoString(str_fmat,"FMhh24");
					break;
				case 'H':
					appendStringInfoString(str_fmat,"hh24");		
					break;
				case 'i':
					appendStringInfoString(str_fmat,"MI");                          
					break;
				case 'j':
					appendStringInfoString(str_fmat,"DDD");                         
					break;
				case 'r':
					appendStringInfoString(str_fmat,"HH:MI:ss AM");
					break;
				case 's':
				case 'S':
					appendStringInfoString(str_fmat,"ss");
					break;
				case 'f':
					appendStringInfoString(str_fmat,"US");
					break;
				case 'p':                                       // AM/PM
					appendStringInfoString(str_fmat,"AM");
					break;
				case 'T':
					appendStringInfoString(str_fmat,"HH24:MI:ss");
					break;
				case 'W':
					appendStringInfoString(str_fmat,"FMDay");
					break;
				case 'u':
					appendStringInfoString(str_fmat,"WW");
					break;
				default:
					appendBinaryStringInfo(str_fmat,"\"",1);
					appendBinaryStringInfo(str_fmat,ptr,1);
					appendBinaryStringInfo(str_fmat,"\"",1);
            }
		}
		else 
		{
			appendBinaryStringInfo(str_fmat,"\"",1);
			appendBinaryStringInfo(str_fmat,ptr,1);
			appendBinaryStringInfo(str_fmat,"\"",1);
		}
	}
}

Datum
myfce_date_format(PG_FUNCTION_ARGS)
{
      Timestamp ts = PG_GETARG_TIMESTAMP(0);
      text *t1 = PG_GETARG_TEXT_PP(1);
      text *result = NULL;

      StringInfoData str_fmat;
      initStringInfo(&str_fmat);
      parse_date_time_format(VARDATA_ANY(t1), VARSIZE_ANY_EXHDR(t1),&str_fmat);
      result = DatumGetTextP(DirectFunctionCall2(timestamp_to_char,TimestampGetDatum(ts),PointerGetDatum(cstring_to_text_with_len(str_fmat.data,str_fmat.len))));

      //DatumGetInt32
      PG_RETURN_TEXT_P(result);
}

Datum
myfce_date_format_timestamptz(PG_FUNCTION_ARGS)
{
      TimestampTz ts = PG_GETARG_TIMESTAMP(0);
      text *t1 = PG_GETARG_TEXT_PP(1);
      text *result = NULL;


      StringInfoData str_fmat;
      initStringInfo(&str_fmat);
      parse_date_time_format(VARDATA_ANY(t1), VARSIZE_ANY_EXHDR(t1),&str_fmat);
      result = DatumGetTextP(DirectFunctionCall2(timestamptz_to_char,TimestampGetDatum(ts),PointerGetDatum(cstring_to_text_with_len(str_fmat.data,str_fmat.len))));

      PG_RETURN_TEXT_P(result);
}

/*
 * lightdb change at 2023/02/17 for mysql compatible str_to_date
 */
Datum
myfce_str_to_date(PG_FUNCTION_ARGS)
{
	text *date_txt = PG_GETARG_TEXT_PP(0);
	text *fmt = PG_GETARG_TEXT_PP(1);
	Timestamp result;
	int			tz;
	struct pg_tm tm;
	fsec_t		fsec;
	int			fprec;
	bool		return_null = false;

	StringInfoData str_fmat;
	initStringInfo(&str_fmat);

	parse_date_time_format(VARDATA_ANY(fmt), VARSIZE_ANY_EXHDR(fmt), &str_fmat);

	lt_do_to_timestamp(date_txt, cstring_to_text_with_len(str_fmat.data,str_fmat.len), InvalidOid, true,
					&tm, &fsec, &fprec, NULL, NULL, &return_null);

	if (return_null)
		PG_RETURN_NULL();

	/* Use the specified time zone, if any. */
	if (tm.tm_zone)
	{
		int			dterr = DecodeTimezone(unconstify(char *, tm.tm_zone), &tz);

		if (dterr)
			DateTimeParseError(dterr, text_to_cstring(date_txt), "timestamptz");
	}
	else
		tz = DetermineTimeZoneOffset(&tm, session_timezone);
	
	if (tm2timestamp(&tm, fsec, &tz, &result) != 0)
		ereport(ERROR,
				(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
				 errmsg("timestamp out of range")));

	/* Use the specified fractional precision, if any. */
	if (fprec)
		AdjustTimestampForTypmod(&result, fprec);

	result = DatumGetTimestamp(DirectFunctionCall1(timestamptz_timestamp, TimestampGetDatum(result)));

	PG_RETURN_TIMESTAMP(result);
}

/*
 * lightdb add at 2023/02/13 for mysql compatible str_to_date
 * str_to_date2 return date
 */
Datum 
myfce_str_to_date2(PG_FUNCTION_ARGS)
{
	text *date_txt = PG_GETARG_TEXT_PP(0);
	text *fmt = PG_GETARG_TEXT_PP(1);

	DateADT		result;
	struct pg_tm tm;
	fsec_t		fsec;

	bool return_null = false;
	StringInfoData strfmt;

	initStringInfo(&strfmt);
	parse_date_time_format(VARDATA_ANY(fmt), VARSIZE_ANY_EXHDR(fmt), &strfmt);

	lt_do_to_timestamp(date_txt, cstring_to_text_with_len(strfmt.data, strfmt.len), InvalidOid, false,
					&tm, &fsec, NULL, NULL, NULL, &return_null);
	
	if (return_null)
		PG_RETURN_NULL();

	/* Prevent overflow in Julian-day routines */
	if (!IS_VALID_JULIAN(tm.tm_year, tm.tm_mon, tm.tm_mday))
		ereport(ERROR,
				(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
				 errmsg("date out of range: \"%s\"",
						text_to_cstring(date_txt))));

	result = date2j(tm.tm_year, tm.tm_mon, tm.tm_mday) - POSTGRES_EPOCH_JDATE;

	/* Now check for just-out-of-range dates */
	if (!IS_VALID_DATE(result))
		ereport(ERROR,
				(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
				 errmsg("date out of range: \"%s\"",
						text_to_cstring(date_txt))));

	PG_RETURN_DATEADT(result);
}

/*
 * lightdb add at 2023/02/13 for mysql compatible str_to_date
 * str_to_date3 return time
 */
Datum 
myfce_str_to_date3(PG_FUNCTION_ARGS)
{
	text *time_txt = PG_GETARG_TEXT_PP(0);
	text *fmt = PG_GETARG_TEXT_PP(1);
	TimeADT		result;
	struct pg_tm tm;
	fsec_t 		fsec;
	int32 typmod = -1;
	bool return_null = false;

	StringInfoData strfmt;
	initStringInfo(&strfmt);

	parse_date_time_format(VARDATA_ANY(fmt), VARSIZE_ANY_EXHDR(fmt), &strfmt);

	lt_do_to_timestamp(time_txt, cstring_to_text_with_len(strfmt.data, strfmt.len), InvalidOid, false,
					&tm, &fsec, NULL, NULL, NULL, &return_null);

	if (return_null)
		PG_RETURN_NULL();

	tm2time(&tm, fsec, &result);
	AdjustTimeForTypmod(&result, typmod);

	PG_RETURN_TIMEADT(result);
}

Datum myfce_zlib_compress(PG_FUNCTION_ARGS)
{
    text *source = PG_GETARG_TEXT_PP(0);
	size_t orig_len = VARSIZE_ANY_EXHDR(source);
	int dest_len = orig_len * 120 / 100 + 12;
	bytea *res = (bytea *)palloc(dest_len + BLOB_HEADER + VARHDRSZ);
	uLongf compressed_size = dest_len;
	char *buf = palloc(dest_len + BLOB_HEADER);

	memset(buf, 0, dest_len + BLOB_HEADER);

	if (orig_len)
	{
		compress2((Bytef *)(buf + BLOB_HEADER), &compressed_size, (const Bytef *)(char *)VARDATA_ANY(source), (uLong)orig_len, -1);
		/* Store compressed blob in machine independent format */
		int4store(buf, (uint32) orig_len);
		SET_VARSIZE(res, compressed_size + BLOB_HEADER + VARHDRSZ);
		memcpy((char *)VARDATA_ANY(res), buf, dest_len + BLOB_HEADER);
		pfree(buf);
	}
	else
	{
		SET_VARSIZE(res, VARHDRSZ);
	}

	PG_RETURN_BYTEA_P(res);
}

Datum myfce_zlib_decompress(PG_FUNCTION_ARGS)
{
    bytea *source = PG_GETARG_BYTEA_PP(0);
	int orig_len = VARSIZE_ANY_EXHDR(source);
	int dest_len = (orig_len) ? uint4korr((char *)VARDATA_ANY(source)) : 0;
	text *res = (text *)palloc(dest_len + VARHDRSZ);
	uLongf compressed_size = dest_len;

	SET_VARSIZE(res, dest_len + VARHDRSZ);

	if (dest_len)
		uncompress((Bytef *)(char *)VARDATA_ANY(res), &compressed_size, (Bytef *)((char *)VARDATA_ANY(source) + BLOB_HEADER), (uLong)(orig_len - BLOB_HEADER));
	
	PG_RETURN_TEXT_P(res);
}

int
my_mb_strlen(text *str, char **sizes, int **positions)
{
	int r_len;
	int cur_size = 0;
	int sz;
	char *p;
	int cur = 0;

	p = VARDATA_ANY(str);
	r_len = VARSIZE_ANY_EXHDR(str);

	if (NULL != sizes)
		*sizes = palloc(r_len * sizeof(char));
	if (NULL != positions)
		*positions = palloc(r_len * sizeof(int));

	while (cur < r_len)
	{
		sz = _pg_mblen(p);
		if (sizes)
			(*sizes)[cur_size] = sz;
		if (positions)
			(*positions)[cur_size] = cur;
		cur += sz;
		p += sz;
		cur_size += 1;
	}

	return cur_size;
}

static int
my_instr_mb(text *txt, text *pattern, int start, int nth)
{
	int			c_len_txt, c_len_pat;
	int			b_len_pat;
	int		   *pos_txt;
	const char *str_txt, *str_pat;
	int			beg, end, i, dx;

	str_txt = VARDATA_ANY(txt);
	c_len_txt = my_mb_strlen(txt, NULL, &pos_txt);
	str_pat = VARDATA_ANY(pattern);
	b_len_pat = VARSIZE_ANY_EXHDR(pattern);
	c_len_pat = pg_mbstrlen_with_len(str_pat, b_len_pat);

	if (start > 0)
	{
		dx = 1;
		beg = start - 1;
		end = c_len_txt - c_len_pat + 1;
		if (beg >= end)
			return 0;	/* out of range */
	}
	else
	{
		dx = -1;
		beg = Min(c_len_txt + start, c_len_txt - c_len_pat);
		end = -1;
		if (beg <= end)
			return 0;	/* out of range */
	}

	for (i = beg; i != end; i += dx)
	{
		if (memcmp(str_txt + pos_txt[i], str_pat, b_len_pat) == 0)
		{
			if (--nth == 0)
				return i + 1;
		}
	}

	return 0;
}

int
my_instr(text *txt, text *pattern, int start, int nth)
{
	int			len_txt, len_pat;
	const char *str_txt, *str_pat;
	int			beg, end, i, dx;

	if (nth <= 0)
		PARAMETER_ERROR("Four parameter isn't positive.");

	/* Forward for multibyte strings */
	if (pg_database_encoding_max_length() > 1)
		return my_instr_mb(txt, pattern, start, nth);

	str_txt = VARDATA_ANY(txt);
	len_txt = VARSIZE_ANY_EXHDR(txt);
	str_pat = VARDATA_ANY(pattern);
	len_pat = VARSIZE_ANY_EXHDR(pattern);

	if (start > 0)
	{
		dx = 1;
		beg = start - 1;
		end = len_txt - len_pat + 1;
		if (beg >= end)
			return 0;	/* out of range */
	}
	else
	{
		dx = -1;
		beg = Min(len_txt + start, len_txt - len_pat);
		end = -1;
		if (beg <= end)
			return 0;	/* out of range */
	}

	for (i = beg; i != end; i += dx)
	{
		if (memcmp(str_txt + i, str_pat, len_pat) == 0)
		{
			if (--nth == 0)
				return i + 1;
		}
	}

	return 0;
}

Datum
myfce_plvstr_instr2 (PG_FUNCTION_ARGS)
{
	text *arg1 = PG_GETARG_TEXT_PP(0);
	text *arg2 = PG_GETARG_TEXT_PP(1);

	PG_RETURN_INT32(my_instr(arg1, arg2, 1, 1));
}


/**
 * @note: compliant to mysql's behaviour
 *  a): len == -1 means a magic number for mysql_substr2
 * @ref: https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_substr
 * @date: 2023-03-10
 * @author lightdb
 * 
*/
static text *
mysql_substr(Datum str, int pos, int len)
{
	if(pos == 0)
	{
		return cstring_to_text("");
	}

	/*If pos < 0, check left most first*/
	if (pos < 0)
	{
		text   *t;
		int32	n;

		t = DatumGetTextPP(str);
		n = pg_mbstrlen_with_len(VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t));
		pos = n + pos + 1;
		if (pos <= 0)
			return cstring_to_text("");
		str = PointerGetDatum(t);/* save detoasted text */
	}

	if (len < 0)
		return DatumGetTextP(DirectFunctionCall2(text_substr_no_len,
			str, Int32GetDatum(pos)));
	else
		return DatumGetTextP(DirectFunctionCall3(text_substr,
			str, Int32GetDatum(pos), Int32GetDatum(len)));
}


Datum
mysql_substr2(PG_FUNCTION_ARGS)
{
	if(PG_ARGISNULL(0) || PG_ARGISNULL(1))
		PG_RETURN_NULL();

	PG_RETURN_TEXT_P(mysql_substr(PG_GETARG_DATUM(0), PG_GETARG_INT32(1), -1));
}

Datum
mysql_substr3(PG_FUNCTION_ARGS)
{
	int32 len;
	if(PG_ARGISNULL(0) || PG_ARGISNULL(1) || PG_ARGISNULL(2))
		PG_RETURN_NULL();

	len = PG_GETARG_INT32(2);
	if (len < 1)
		return DatumGetTextP(cstring_to_text(""));
	PG_RETURN_TEXT_P(mysql_substr(PG_GETARG_DATUM(0), PG_GETARG_INT32(1), len));
}

//LightDB add on 2023/04/27 for s202304244701
Datum
myfce_sysdate_0(PG_FUNCTION_ARGS)
{
	return TimestampGetDatum(GetMysqlSysdate(0));
}

/*
Datum
myfce_sysdate_1(PG_FUNCTION_ARGS)
{
	return TimestampGetDatum(GetMysqlSysdate(PG_GETARG_INT32(0)));
}
*/