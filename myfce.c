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


#include "../../src/backend/utils/adt/jsonpath_exec.c"
#include "../../src/backend/utils/adt/jsonfuncs.c"
#include "../../src/backend/utils/adt/jsonb.c"

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

//LightDB add on 2023/05/22 for JSON API
PG_FUNCTION_INFO_V1(myfce_json_array);
PG_FUNCTION_INFO_V1(myfce_json_object);
PG_FUNCTION_INFO_V1(myfce_json_extract);
PG_FUNCTION_INFO_V1(myfce_json_contains_path);
PG_FUNCTION_INFO_V1(text_bool_equal);
PG_FUNCTION_INFO_V1(text_bool_not_equal);

//LightDB add on 2023/09/11 for JSON API
PG_FUNCTION_INFO_V1(myfce_json_remove);
PG_FUNCTION_INFO_V1(myfce_json_insert);
PG_FUNCTION_INFO_V1(myfce_json_replace);
PG_FUNCTION_INFO_V1(myfce_json_set);


/* LightDB add at 2023/12/04 for 202310213118, quarter function */
PG_FUNCTION_INFO_V1(quarter_ts);

/* LightDB add at 2023/12/04 for 202310213117, support last_day */
PG_FUNCTION_INFO_V1(my_last_day);

/* LightDB add for 202311014178 */
PG_FUNCTION_INFO_V1(lt_myfce_date_add_days);
PG_FUNCTION_INFO_V1(lt_myfce_date_sub_days);
PG_FUNCTION_INFO_V1(lt_myfce_days_sub_date);
PG_FUNCTION_INFO_V1(lt_myfce_date_add_days_numeric);
PG_FUNCTION_INFO_V1(lt_myfce_date_sub_days_numeric);
PG_FUNCTION_INFO_V1(lt_myfce_days_sub_date_numeric);

static int64 LtDateFormatToInt8(DateADT dateVal);

static void
JsonpathItemString(StringInfo buf, JsonPathItem *v);
static void
transformJsonpath(JsonPath *jp, Datum **path_elems, bool **path_nulls, int *path_len, bool chroot);

/* Follow three functions are shamelessly stolen from the 'jsonfuncs.c'
   We did some tiny changes for these functions, for keeping a consistent behave with mysql.
   the changes are:
   1. mysqlSetPathArray will not report a error while translate a string to number;
   2. these functions will be called by each other; */
static JsonbValue *
mysqlSetPath(JsonbIterator **it, Datum *path_elems,
			 bool *path_nulls, int path_len,
			 JsonbParseState **st, int level, Jsonb *newval, int op_type);
static void
mysqlSetPathArray(JsonbIterator **it, Datum *path_elems, bool *path_nulls,
				  int path_len, JsonbParseState **st, int level,
				  Jsonb *newval, uint32 nelems, int op_type);
static void
mysqlSetPathObject(JsonbIterator **it, Datum *path_elems, bool *path_nulls,
				   int path_len, JsonbParseState **st, int level,
				   Jsonb *newval, uint32 npairs, int op_type);

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
	/* 除非null值，否则追加值到字符串末尾*/
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		/* 第一次，我们忽略分隔符。*/
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
		{
			/* delimiter */
			/* 追加分隔符*/
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));
		}

		/* 将值追加到末尾 */
		appendStringInfoText(state, PG_GETARG_TEXT_PP(2));
	}

	/*
	 * The transition type for group_concat() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 * group_concat() 的转换类型被声明为 “内部”、 这是一种按值传递类型，大小与指针相同。
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
	/* 除非null值，否则追加值到字符串末尾*/
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		/* 第一次，我们忽略分隔符。*/
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg0 = PG_GETARG_INT64(2);
		appendStringInfo(state, INT64_FORMAT, arg0);
	}

	/*
	 * The transition type for group_concat() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 * group_concat() 的转换类型被声明为 “内部”、 这是一种按值传递类型，大小与指针相同。
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
	/* 除非null值，否则追加值到字符串末尾*/
	if (!PG_ARGISNULL(2))
	{
		/* On the first time through, we ignore the delimiter. */
		/* 第一次，我们忽略分隔符。*/
		if (state == NULL)
			state = makeStringAggState(fcinfo);
		else if (!PG_ARGISNULL(1))
			appendStringInfoText(state, PG_GETARG_TEXT_PP(1));	/* delimiter */

		arg2 = PG_GETARG_FLOAT8(2);
		appendStringInfoString(state, DatumGetCString(DirectFunctionCall1(float8out, Float8GetDatum(arg2))));
	}

	/*
	 * The transition type for group_concat() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 * group_concat() 的转换类型被声明为 “内部”、 这是一种按值传递类型，大小与指针相同。
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
	/* 除非null值，否则追加值到字符串末尾*/
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
	 * The transition type for group_concat() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 * group_concat() 的转换类型被声明为 “内部”、 这是一种按值传递类型，大小与指针相同。
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
	/* 除非null值，否则追加值到字符串末尾*/
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
	 * The transition type for group_concat() is declared to be "internal",
	 * which is a pass-by-value type the same size as a pointer.
	 * group_concat() 的转换类型被声明为 “内部”、 这是一种按值传递类型，大小与指针相同。
	 */
	PG_RETURN_POINTER(state);
}


Datum
myfce_group_concat_finalfn(PG_FUNCTION_ARGS)
{
	StringInfo	state;

	/* cannot be called directly because of internal-type argument */
	/* 不能直接调用，因为内部类型参数*/
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
	/* 如果 arg0 包含逗号，则返回 0、*/
	for ( i=1;i<arg0.len-1;i++)
	{
		if(arg0.data[i] == ',')
		{
			PG_RETURN_INT32(0);
		}
	}

	// find  sub string  of ",arg1,"
	/* 查找“,arg1, ”的子串*/
	ret = strstr(arg1.data, arg0.data);
	if(!ret)
	{
		PG_RETURN_INT32(0);
	}
	//caculate count of ','
	/* 计算','的数量*/
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
	/* 如果 pos < 0，则先检查最左边*/
	if (pos < 0)
	{
		text   *t;
		int32	n;

		t = DatumGetTextPP(str);
		n = pg_mbstrlen_with_len(VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t));
		pos = n + pos + 1;
		if (pos <= 0)
			return cstring_to_text("");
		/* save detoasted text */
		/* 保存已解密文本*/
		str = PointerGetDatum(t);
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
	/*a len less than 1 should always return empty string*/
	/* len 小于 1 时应始终返回空字符串*/
	if (len < 1)
		PG_RETURN_TEXT_P(cstring_to_text(""));
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

//LightDB add on 2023/05/22 for JSON API

Datum
myfce_json_array(PG_FUNCTION_ARGS)
{
	return jsonb_build_array(fcinfo);
}

Datum
myfce_json_object(PG_FUNCTION_ARGS)
{
	return jsonb_build_object(fcinfo);
}

Datum
myfce_json_extract(PG_FUNCTION_ARGS)
{
	Jsonb	   *jb = PG_GETARG_JSONB_P(0);
	JsonPath   *jp = PG_GETARG_JSONPATH_P(1);
	JsonValueList found = {0};
	Jsonb	   *vars = DatumGetJsonbP(jsonb_from_cstring("{}", 2));
	int		len = 0;

	(void) executeJsonPath(jp, vars, jb, false, &found, false);

	len = JsonValueListLength(&found);
	/* if len = 0, return NULL instead of empty json array '[]' 
	 * if len = 1,  return single json value
	 * else , return array
	 *
	 * 如果len等于0 ，返回 NULL，而不是空 json 数组"[]
	 * 如果len等于1 ，返回单值
	 * 否则，返回数组
	*/
	if (len == 0)
	{
		PG_RETURN_NULL();
	}
	else if (len == 1 && !found.range) 
	{
		PG_RETURN_JSONB_P(JsonbValueToJsonb(JsonValueListHead(&found)));
	}

	PG_RETURN_JSONB_P(JsonbValueToJsonb(wrapItemsInArray(&found)));
}

Datum
myfce_json_contains_path(PG_FUNCTION_ARGS)
{
	Jsonb	   *jb = PG_GETARG_JSONB_P(0);
	char *mode = text_to_cstring(PG_GETARG_TEXT_PP(1));
	ArrayType *jps = PG_GETARG_ARRAYTYPE_P(2);
	int		nelems = ArrayGetNItems(ARR_NDIM(jps), ARR_DIMS(jps));
	Jsonb	 *vars = DatumGetJsonbP(jsonb_from_cstring("{}", 2));
	bool oneNotAll = false;
	int i;

	Datum *datumArray = NULL;
	bool *datumArrayNulls = NULL;
	int datumArrayLength = 0;
	bool typeByVal = false;
	char typeAlign = 0;
	int16 typeLength = 0;
	Oid typeId = ARR_ELEMTYPE(jps);

	/* check mode */
	/* 模式校验*/
	if ( strlen(mode) == 3 &&
		 ( strcasecmp(mode, "all") == 0 || strcasecmp(mode, "one") == 0 ) )
	{
		oneNotAll = (strcasecmp(mode, "all") == 0) ? false : true; 
	}
	else
	{
		elog(ERROR, "The oneOrAll argument to json_contains_path may take these values: 'one' or 'all'.");
	}

	/* convert to datum array */
	/* 转换为值数组*/
	get_typlenbyvalalign(typeId, &typeLength, &typeByVal, &typeAlign);
	deconstruct_array(jps, typeId, typeLength, typeByVal, typeAlign,
					  &datumArray, &datumArrayNulls, &datumArrayLength);

	/* check paths */
	/* 检查路径*/
	if (oneNotAll)
	{
		for (i = 0; i < nelems; i++)
		{
			if (datumArray[i] != 0)
			{
				JsonPath *jp = DatumGetJsonPathP(datumArray[i]);
				if (executeJsonPath(jp, vars, jb, false, NULL, false) == jperOk)
				{
					PG_RETURN_BOOL(true);
				}
			}
		}
		PG_RETURN_BOOL(false);
	}
	else
	{
		for (i = 0; i < nelems; i++)
		{
			if (datumArray[i] != 0)
			{
				JsonPath *jp = DatumGetJsonPathP(datumArray[i]);
				if (executeJsonPath(jp, vars, jb, false, NULL, false) != jperOk)
				{
					PG_RETURN_BOOL(false);
				}
			}
			else
			{
				PG_RETURN_BOOL(false);
			}
		}
		PG_RETURN_BOOL(true);
	}
}

static void
mysqlSetPathObject(JsonbIterator **it, Datum *path_elems, bool *path_nulls,
			  int path_len, JsonbParseState **st, int level,
			  Jsonb *newval, uint32 npairs, int op_type)
{
	JsonbValue	v;
	int			i;
	JsonbValue	k;
	bool		done = false;

	if (level >= path_len || path_nulls[level])
		done = true;

	/* empty object is a special case for create */
	if ((npairs == 0) && (op_type & JB_PATH_CREATE_OR_INSERT) &&
		(level == path_len - 1))
	{
		JsonbValue	newkey;

		newkey.type = jbvString;
		newkey.val.string.len = VARSIZE_ANY_EXHDR(path_elems[level]);
		newkey.val.string.val = VARDATA_ANY(path_elems[level]);

		(void) pushJsonbValue(st, WJB_KEY, &newkey);
		addJsonbToParseState(st, newval);
	}

	for (i = 0; i < npairs; i++)
	{
		JsonbIteratorToken r = JsonbIteratorNext(it, &k, true);

		Assert(r == WJB_KEY);

		if (!done &&
			k.val.string.len == VARSIZE_ANY_EXHDR(path_elems[level]) &&
			memcmp(k.val.string.val, VARDATA_ANY(path_elems[level]),
				   k.val.string.len) == 0)
		{
			if (level == path_len - 1)
			{
				/*
				 * called from jsonb_insert(), it forbids redefining an
				 * existing value
				 * 调用 jsonb_insert()，它禁止重新定义现有值
				 */
				if (op_type & (JB_PATH_INSERT_BEFORE | JB_PATH_INSERT_AFTER))
					ereport(ERROR,
							(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
							 errmsg("cannot replace existing key"),
							 errhint("Try using the function jsonb_set "
									 "to replace key value.")));
				/* skip value */
				/* 跳过值 */
				r = JsonbIteratorNext(it, &v, true);
				if (!(op_type & JB_PATH_DELETE))
				{
					(void) pushJsonbValue(st, WJB_KEY, &k);
					addJsonbToParseState(st, newval);
				}
				done = true;
			}
			else
			{
				(void) pushJsonbValue(st, r, &k);
				mysqlSetPath(it, path_elems, path_nulls, path_len,
						st, level + 1, newval, op_type);
			}
		}
		else
		{
			if ((op_type & JB_PATH_CREATE_OR_INSERT) && !done &&
				level == path_len - 1 && i == npairs - 1)
			{
				JsonbValue	newkey;

				newkey.type = jbvString;
				newkey.val.string.len = VARSIZE_ANY_EXHDR(path_elems[level]);
				newkey.val.string.val = VARDATA_ANY(path_elems[level]);

				(void) pushJsonbValue(st, WJB_KEY, &newkey);
				addJsonbToParseState(st, newval);
			}

			(void) pushJsonbValue(st, r, &k);
			r = JsonbIteratorNext(it, &v, false);
			(void) pushJsonbValue(st, r, r < WJB_BEGIN_ARRAY ? &v : NULL);
			if (r == WJB_BEGIN_ARRAY || r == WJB_BEGIN_OBJECT)
			{
				int			walking_level = 1;

				while (walking_level != 0)
				{
					r = JsonbIteratorNext(it, &v, false);

					if (r == WJB_BEGIN_ARRAY || r == WJB_BEGIN_OBJECT)
						++walking_level;
					if (r == WJB_END_ARRAY || r == WJB_END_OBJECT)
						--walking_level;

					(void) pushJsonbValue(st, r, r < WJB_BEGIN_ARRAY ? &v : NULL);
				}
			}
		}
	}
}

static void
mysqlSetPathArray(JsonbIterator **it, Datum *path_elems, bool *path_nulls,
			 int path_len, JsonbParseState **st, int level,
			 Jsonb *newval, uint32 nelems, int op_type)
{
	JsonbValue	v;
	int			idx,
				i;
	bool		done = false;

	/* pick correct index */
	/* 选择正确的索引*/
	if (level < path_len && !path_nulls[level])
	{
		char	   *c = TextDatumGetCString(path_elems[level]);
		long		lindex;
		char	   *badp;

		errno = 0;
		lindex = strtol(c, &badp, 10);
		if (errno != 0 || badp == c || *badp != '\0' || lindex > INT_MAX ||
			lindex < INT_MIN)
		{
			/* don't report a error, just stop recursion */
			/* 不报错，只停止递归*/
			lindex = -1;
			level = path_len;
		}
		idx = lindex;
	}
	else
		idx = nelems;

	if (idx < 0)
	{
		if (-idx > nelems)
			idx = INT_MIN;
		else
			idx = nelems + idx;
	}

	if (idx > 0 && idx > nelems)
		idx = nelems;

	/*
	 * if we're creating, and idx == INT_MIN, we prepend the new value to the
	 * array also if the array is empty - in which case we don't really care
	 * what the idx value is
	 * 
	 * 如果我们正在创建数组，并且 idx == INT_MIN，我们会将新值预置到数组中，
	 * 如果数组是空的，我们也会将新值预置到数组中。idx值是多少
	 */

	if ((idx == INT_MIN || nelems == 0) && (level == path_len - 1) &&
		(op_type & JB_PATH_CREATE_OR_INSERT))
	{
		LtAssert(newval != NULL);
		addJsonbToParseState(st, newval);
		done = true;
	}

	/* iterate over the array elements */
	/* 遍历数组元素*/
	for (i = 0; i < nelems; i++)
	{
		JsonbIteratorToken r;

		if (i == idx && level < path_len)
		{
			if (level == path_len - 1)
			{
				r = JsonbIteratorNext(it, &v, true);	/* skip */

				if (op_type & (JB_PATH_INSERT_BEFORE | JB_PATH_CREATE))
					addJsonbToParseState(st, newval);

				/*
				 * We should keep current value only in case of
				 * JB_PATH_INSERT_BEFORE or JB_PATH_INSERT_AFTER because
				 * otherwise it should be deleted or replaced
				 * 
				 * 只有在 JB_PATH_INSERT_BEFORE 或 JB_PATH_INSERT_AFTER 的情况下，
				 * 我们才应保留当前值，因为否则应删除或替换
				 */
				if (op_type & (JB_PATH_INSERT_AFTER | JB_PATH_INSERT_BEFORE))
					(void) pushJsonbValue(st, r, &v);

				if (op_type & (JB_PATH_INSERT_AFTER | JB_PATH_REPLACE))
					addJsonbToParseState(st, newval);

				done = true;
			}
			else
				(void) mysqlSetPath(it, path_elems, path_nulls, path_len,
								st, level + 1, newval, op_type);
		}
		else
		{
			r = JsonbIteratorNext(it, &v, false);

			(void) pushJsonbValue(st, r, r < WJB_BEGIN_ARRAY ? &v : NULL);

			if (r == WJB_BEGIN_ARRAY || r == WJB_BEGIN_OBJECT)
			{
				int			walking_level = 1;

				while (walking_level != 0)
				{
					r = JsonbIteratorNext(it, &v, false);

					if (r == WJB_BEGIN_ARRAY || r == WJB_BEGIN_OBJECT)
						++walking_level;
					if (r == WJB_END_ARRAY || r == WJB_END_OBJECT)
						--walking_level;

					(void) pushJsonbValue(st, r, r < WJB_BEGIN_ARRAY ? &v : NULL);
				}
			}

			if ((op_type & JB_PATH_CREATE_OR_INSERT) && !done &&
				level == path_len - 1 && i == nelems - 1)
			{
				addJsonbToParseState(st, newval);
			}
		}
	}
}

static JsonbValue *
mysqlSetPath(JsonbIterator **it, Datum *path_elems,
		bool *path_nulls, int path_len,
		 JsonbParseState **st, int level, Jsonb *newval, int op_type)
{
	JsonbValue	v;
	JsonbIteratorToken r;
	JsonbValue *res;

	check_stack_depth();

	if (path_nulls[level])
		ereport(ERROR,
				(errcode(ERRCODE_NULL_VALUE_NOT_ALLOWED),
				 errmsg("path element at position %d is null",
						level + 1)));

	r = JsonbIteratorNext(it, &v, false);

	switch (r)
	{
		case WJB_BEGIN_ARRAY:
			(void) pushJsonbValue(st, r, NULL);
			mysqlSetPathArray(it, path_elems, path_nulls, path_len, st, level,
						 newval, v.val.array.nElems, op_type);
			r = JsonbIteratorNext(it, &v, false);
			Assert(r == WJB_END_ARRAY);
			res = pushJsonbValue(st, r, NULL);
			break;
		case WJB_BEGIN_OBJECT:
			(void) pushJsonbValue(st, r, NULL);
			mysqlSetPathObject(it, path_elems, path_nulls, path_len, st, level,
						  newval, v.val.object.nPairs, op_type);
			r = JsonbIteratorNext(it, &v, true);
			Assert(r == WJB_END_OBJECT);
			res = pushJsonbValue(st, r, NULL);
			break;
		case WJB_ELEM:
		case WJB_VALUE:
			res = pushJsonbValue(st, r, &v);
			break;
		default:
			elog(ERROR, "unrecognized iterator result: %d", (int) r);
			res = NULL;			/* keep compiler quiet */
			break;
	}

	return res;
}

//LightDB add on 2023/09/11 for JSON API (decode jsonpath to string)
static void
JsonpathItemString(StringInfo buf, JsonPathItem *v)
{
	JsonPathItem elem;

	check_stack_depth();
	CHECK_FOR_INTERRUPTS();

	switch (v->type)
	{
	case jpiRoot:
		appendStringInfoChar(buf, '$');
		break;
	case jpiKey:
		appendStringInfoString(buf, jspGetString(v, NULL));
		break;
	case jpiIndexArray:
		{
			JsonPathItem from;
			JsonPathItem to;
			bool range = jspGetArraySubscript(v, &from, &to, 0);
			if (range || v->content.array.nelems > 1)
			{
				ereport(ERROR, (errcode(ERRCODE_MORE_THAN_ONE_SQL_JSON_ITEM),
								errmsg("In this situation, path expressions may not contain the * and ** tokens or an array range.")));
			}
			JsonpathItemString(buf, &from);
			break;
		}
	case jpiAny:
	case jpiAnyKey:
	case jpiAnyArray:
		ereport(ERROR, (errcode(ERRCODE_MORE_THAN_ONE_SQL_JSON_ITEM),
						errmsg("In this situation, path expressions may not contain the * and ** tokens or an array range.")));
		break;
	case jpiNumeric:
		{
			long index;
			char cbuf[32];
			Datum result;
			result = DirectFunctionCall1(numeric_int8, NumericGetDatum(jspGetNumeric(v)));
			index = DatumGetInt64(result);
			
			if (index < 0)
			{
				ereport(ERROR, (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
								errmsg("Invalid JSON path expression.")));
			}
			snprintf(cbuf, sizeof(cbuf), "%ld", index);
			appendStringInfoString(buf, cbuf);
			break;
		}
	case jpiLast: /* for '[last]' */
		appendBinaryStringInfo(buf, "-1", 2);
		break;
	case jpiSub: /* for '[last - N]' */
		{
			long index;
			char cbuf[32];
			Datum result;
			jspGetLeftArg(v, &elem);
			if (elem.type != jpiLast)
			{
				ereport(ERROR, (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
								errmsg("Invalid JSON path expression.")));
			}
			jspGetRightArg(v, &elem);
			if (elem.type != jpiNumeric)
			{
				ereport(ERROR, (errcode(ERRCODE_NON_NUMERIC_SQL_JSON_ITEM),
								errmsg("Invalid JSON path expression.")));
			}
			result = DirectFunctionCall1(numeric_int8,
										 NumericGetDatum(jspGetNumeric(&elem)));
			index = DatumGetInt64(result);

			/* translate '[last - N]' to '-(N+1)' */
			index++;
			snprintf(cbuf, sizeof(cbuf), "-%ld", index);
			appendStringInfoString(buf, cbuf);
			break;
		}
	default:
		ereport(ERROR, (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
						errmsg("Invalid JSON path expression.")));
	}
}

// LightDB add on 2023/09/11 for JSON API (convert json path to pg json path array)
// These function should only be used by insert, replace and set
static void
transformJsonpath(JsonPath *jp, Datum **path_elems, bool **path_nulls, int *path_len, bool chroot)
{
	JsonPathItem jsp;
	JsonPathItem* p_jsp = &jsp;
	JsonPathItem next;
	StringInfoData buf;
	int i;

	jspInit(&jsp, jp);

	/* get first element */
	/*  取第一元素*/
	initStringInfo(&buf);
	JsonpathItemString(&buf, p_jsp);

	/* get the length of jsonpath */
	/* 获取 jsonpath 的长度*/
	*path_len = 1;
	while ( jspGetNext(p_jsp, &next) )
	{
		p_jsp = &next;
		(*path_len)++;
	}

	/* modify '$' is not permitted */
	/* 获取 jsonpath 的长度*/
	if (!chroot && *path_len == 1 && strcmp(buf.data, "$") == 0)
	{
		ereport(ERROR, (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
						errmsg("The path expression '$' is not allowed in this context.")));
	}

	/* ignore first element jpiRoot '$' */
	/* 忽略第一个元素 jpiRoot '$'*/
	p_jsp = &jsp;
	jspGetNext(p_jsp, &next);
	p_jsp = &next;
	(*path_len)--;

	/* these memory units will be freed automatically */
	/* 这些内存单元将被自动释放*/
	*path_elems = (Datum *) palloc(*path_len * sizeof(Datum));
	*path_nulls = (bool *) palloc0(*path_len * sizeof(bool));

	for (i = 0; i < *path_len; i++)
	{
		initStringInfo(&buf);
		JsonpathItemString(&buf, p_jsp);

		jspGetNext(p_jsp, &next);
		p_jsp = &next;

		(*path_elems)[i] = CStringGetTextDatum(buf.data);
		(*path_nulls)[i] = false;
	}
}

Datum
myfce_json_remove(PG_FUNCTION_ARGS)
{
	Jsonb	   *in = PG_GETARG_JSONB_P(0);
	JsonPath   *jp = PG_GETARG_JSONPATH_P(1);
	JsonbValue *res = NULL;
	Datum	   *path_elems;
	bool	   *path_nulls;
	int	 path_len;
	JsonbIterator *it;
	JsonbParseState *st = NULL;
	JsonValueList found = {0};
	int len = 0;

	if (JB_ROOT_IS_SCALAR(in))
	{
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("cannot delete path in scalar")));
	}

	transformJsonpath(jp, &path_elems, &path_nulls, &path_len, false);

	/* for remove without ambiguity
	 用于消除没有歧义的
	 *$.key[N] => {key, N} , $.key.N => {key, N}
	 */
	(void) executeJsonPath(jp, NULL, in, true, &found, false);
	len = JsonValueListLength(&found);
	if (len == 0)
	{
		PG_RETURN_JSONB_P(in);
	}

	it = JsonbIteratorInit(&in->root);

	res = mysqlSetPath(&it, path_elems, path_nulls, path_len, &st,
				   0, NULL, JB_PATH_DELETE);

	LtAssert(res != NULL);

	PG_RETURN_JSONB_P(JsonbValueToJsonb(res));
}

Datum
myfce_json_insert(PG_FUNCTION_ARGS)
{
	Jsonb	   *in = NULL;
	JsonPath   *jp = NULL;
	Datum	newelem;
	Oid	newelem_type;
	JsonbInState result;
	JsonbTypeCategory tcategory;
	Oid			outfuncoid;
	Jsonb	   *newval = NULL;
	JsonbValue *res = NULL;
	Datum	   *path_elems;
	bool	   *path_nulls;
	int	 path_len = -1;
	JsonbIterator *it;
	JsonbParseState *st = NULL;
	JsonValueList found = {0};
	bool is_null = false;
	int len = 0;

	/* mysql.json_insert is defined without 'STRICT' for supporting third null
	   argument, so we need follow check */
	if ( PG_ARGISNULL(0) || PG_ARGISNULL(1) )
	{
		PG_RETURN_NULL();
	}
	if (PG_ARGISNULL(2))
	{
		is_null = true;
	}

	in = PG_GETARG_JSONB_P(0);
	jp = PG_GETARG_JSONPATH_P(1);

	/* covert 'Datum' argument to new value which's type is 'Jsonb' */
	newelem = PG_GETARG_DATUM(2);

	newelem_type = get_fn_expr_argtype(fcinfo->flinfo, 2);
	if (newelem_type == InvalidOid)
	{
		ereport(ERROR, (errcode(ERRCODE_INVALID_PARAMETER_VALUE),
						errmsg("could not determine input data type")));
	}

	jsonb_categorize_type(newelem_type, &tcategory, &outfuncoid);
	memset(&result, 0, sizeof(JsonbInState));
	datum_to_jsonb(newelem, is_null, &result, tcategory, outfuncoid, false);

	newval = JsonbValueToJsonb(result.res);
	transformJsonpath(jp, &path_elems, &path_nulls, &path_len, true);

	/* return input itself while path is exist */
	(void) executeJsonPath(jp, NULL, in, true, &found, false);
	len = JsonValueListLength(&found);
	if (len > 0 || path_len == 0 || JB_ROOT_IS_SCALAR(in))
	{
		PG_RETURN_JSONB_P(in);
	}

	it = JsonbIteratorInit(&in->root);

	res = mysqlSetPath(&it, path_elems, path_nulls, path_len, &st, 0, newval,
				   JB_PATH_INSERT_AFTER);

	LtAssert(res != NULL);

	PG_RETURN_JSONB_P(JsonbValueToJsonb(res));
}

Datum
myfce_json_replace(PG_FUNCTION_ARGS)
{
	Jsonb	   *in = NULL;
	JsonPath   *jp = NULL;
	Datum	newelem;
	Oid	newelem_type;
	JsonbInState result;
	JsonbTypeCategory tcategory;
	Oid			outfuncoid;
	Jsonb	   *newval = NULL;
	JsonbValue *res = NULL;
	Datum	   *path_elems;
	bool	   *path_nulls;
	int	 path_len = -1;
	JsonbIterator *it;
	JsonbParseState *st = NULL;
	JsonValueList found = {0};
	bool is_null = false;
	int len = 0;

	/* mysql.json_insert is defined without 'STRICT' for supporting third null
	   argument, so we need follow check */
	if ( PG_ARGISNULL(0) || PG_ARGISNULL(1) )
	{
		PG_RETURN_NULL();
	}
	if (PG_ARGISNULL(2))
	{
		is_null = true;
	}

	in = PG_GETARG_JSONB_P(0);
	jp = PG_GETARG_JSONPATH_P(1);

	/* covert 'Datum' argument to new value which's type is 'Jsonb' */
	newelem = PG_GETARG_DATUM(2);

	newelem_type = get_fn_expr_argtype(fcinfo->flinfo, 2);
	if (newelem_type == InvalidOid)
	{
		ereport(ERROR, (errcode(ERRCODE_INVALID_PARAMETER_VALUE),
						errmsg("could not determine input data type")));
	}

	jsonb_categorize_type(newelem_type, &tcategory, &outfuncoid);
	memset(&result, 0, sizeof(JsonbInState));
	datum_to_jsonb(newelem, is_null, &result, tcategory, outfuncoid, false);

	newval = JsonbValueToJsonb(result.res);

	/* return input itself while path is exist */
	(void) executeJsonPath(jp, NULL, in, true, &found, false);
	len = JsonValueListLength(&found);
	transformJsonpath(jp, &path_elems, &path_nulls, &path_len, true);
	if (len > 0)
	{
		if (path_len == 0) /* replace $ is allowed in mysql */
		{
			PG_RETURN_JSONB_P(newval);
		}

		it = JsonbIteratorInit(&in->root);

		res = mysqlSetPath(&it, path_elems, path_nulls, path_len, &st, 0, newval,
					   JB_PATH_REPLACE);

		LtAssert(res != NULL);

		PG_RETURN_JSONB_P(JsonbValueToJsonb(res));
	}
	PG_RETURN_JSONB_P(in);
}

Datum
myfce_json_set(PG_FUNCTION_ARGS)
{
	Jsonb	   *in = NULL;
	JsonPath   *jp = NULL;
	JsonValueList found = {0};
	int len = 0;

	if ( PG_ARGISNULL(0) || PG_ARGISNULL(1) )
	{
		PG_RETURN_NULL();
	}

	in = PG_GETARG_JSONB_P(0);
	jp = PG_GETARG_JSONPATH_P(1);

	(void) executeJsonPath(jp, NULL, in, true, &found, false);
	len = JsonValueListLength(&found);
	if (len > 0)
	{
		return myfce_json_replace(fcinfo);
	}
	else
	{
		return myfce_json_insert(fcinfo);
	}
}

static
bool internal_cmp_text_bool(const text *text_value, bool bool_value)
{
	const char *text_str = text_to_cstring(text_value);
	const int len = strlen(text_str);
	const char *bool_str = (bool_value ? "1": "0");
	if (len != 1)
		PG_RETURN_BOOL(false); 

	PG_RETURN_BOOL(!strncmp(text_str, bool_str, len));
}

Datum
text_bool_equal(PG_FUNCTION_ARGS)
{
	const	text *text_value = PG_GETARG_TEXT_P(0);
	bool	bool_value = PG_GETARG_BOOL(1);

	PG_RETURN_BOOL(internal_cmp_text_bool(text_value, bool_value));
}

Datum
text_bool_not_equal(PG_FUNCTION_ARGS)
{
	const	text *text_value = PG_GETARG_TEXT_P(0);
	bool	bool_value = PG_GETARG_BOOL(1);

	PG_RETURN_BOOL(!internal_cmp_text_bool(text_value, bool_value));
}

/* LightDB add at 2023/12/04 for 202310213118, quarter function */
Datum
quarter_ts(PG_FUNCTION_ARGS)
{
	Timestamp	dateTimestamp  = PG_GETARG_TIMESTAMP(0);
	struct 	pg_tm	tm;
	fsec_t	fsec;
										
	timestamp2tm(dateTimestamp, NULL, &tm, &fsec, NULL, NULL);
							
	PG_RETURN_INT32((tm.tm_mon + 2) / 3);
}



/* LightDB add at 2023/12/04 for 202310213117, support last_day */
Datum
my_last_day(PG_FUNCTION_ARGS)
{
	DateADT day = PG_GETARG_DATEADT(0);
	DateADT result;
	int y, m, d;
	j2date(day + POSTGRES_EPOCH_JDATE, &y, &m, &d);
	result = date2j(y, m+1, 1) - POSTGRES_EPOCH_JDATE;

	PG_RETURN_DATEADT(result - 1);
}

/*
 * LightDB add for 202311014178
 *
 * Convert the date type to the int8 type
 */
static int64
LtDateFormatToInt8(DateADT dateVal)
{
	struct 		pg_tm tt, *tm = &tt;
	char		buf[MAXDATELEN + 1];
	int64		date;
	if (DATE_NOT_FINITE(dateVal))
	{
		ereport(ERROR,
				(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
					errmsg("date out of range")));
	}
	j2date(dateVal + POSTGRES_EPOCH_JDATE,
		   &(tm->tm_year), &(tm->tm_mon), &(tm->tm_mday));
	snprintf(buf, sizeof(buf), "%04d%02d%02d", tm->tm_year, tm->tm_mon, tm->tm_mday);
	date = atoi(buf);
	return date;
}

/*
 * LightDB add for 202311014178
 *
 * Date plus number
 */
Datum
lt_myfce_date_add_days(PG_FUNCTION_ARGS)
{
	DateADT		dateVal = PG_GETARG_DATEADT(0);
	int64		days = PG_GETARG_INT64(1);
	int64		intdate, result;

	intdate = LtDateFormatToInt8(dateVal);

	result = DatumGetInt64(DirectFunctionCall2(int8pl, Int64GetDatum(intdate), Int64GetDatum(days)));
	PG_RETURN_INT64(result);
}

/*
 * LightDB add for 202311014178
 *
 * Date minus number
 */
Datum
lt_myfce_date_sub_days(PG_FUNCTION_ARGS)
{
	DateADT		dateVal = PG_GETARG_DATEADT(0);
	int64		days = PG_GETARG_INT64(1);
	int64		intdate, result;

	intdate = LtDateFormatToInt8(dateVal);

	result = DatumGetInt64(DirectFunctionCall2(int8mi, Int64GetDatum(intdate), Int64GetDatum(days)));
	PG_RETURN_INT64(result);
}

/*
 * LightDB add for 202311014178
 *
 * Number minus date
 */
Datum
lt_myfce_days_sub_date(PG_FUNCTION_ARGS)
{
	int64		days = PG_GETARG_INT64(0);
	DateADT		dateVal = PG_GETARG_DATEADT(1);

	int64		intdate, result;

	intdate = LtDateFormatToInt8(dateVal);

	result = DatumGetInt64(DirectFunctionCall2(int8mi, Int64GetDatum(days), Int64GetDatum(intdate)));
	PG_RETURN_INT64(result);
}

/*
 * LightDB add for 202311014178
 *
 * Date plus numeric
 */
Datum
lt_myfce_date_add_days_numeric(PG_FUNCTION_ARGS)
{
	DateADT		dateVal = PG_GETARG_DATEADT(0);
	Datum		days = PG_GETARG_DATUM(1);
	Datum		date, result;
	int64		intdate;

	intdate = LtDateFormatToInt8(dateVal);

	date = DirectFunctionCall1(int8_numeric, Int64GetDatum(intdate));

	result = DirectFunctionCall2(numeric_add, date, days);

	PG_RETURN_DATUM(result);
}

/*
 * LightDB add for 202311014178
 *
 * Date minus numeric
 */
Datum
lt_myfce_date_sub_days_numeric(PG_FUNCTION_ARGS)
{
	DateADT		dateVal = PG_GETARG_DATEADT(0);
	Datum		days = PG_GETARG_DATUM(1);
	Datum		date, result;
	int64		intdate;

	intdate = LtDateFormatToInt8(dateVal);

	date = DirectFunctionCall1(int8_numeric, Int64GetDatum(intdate));

	result = DirectFunctionCall2(numeric_sub, date, days);

	PG_RETURN_DATUM(result);
}

/*
 * LightDB add for 202311014178
 *
 * Numeric minus date
 */
Datum
lt_myfce_days_sub_date_numeric(PG_FUNCTION_ARGS)
{
	Datum		days = PG_GETARG_DATUM(0);
	DateADT		dateVal = PG_GETARG_DATEADT(1);
	Datum		date, result;
	int64		intdate;

	intdate = LtDateFormatToInt8(dateVal);

	date = DirectFunctionCall1(int8_numeric, Int64GetDatum(intdate));

	result = DirectFunctionCall2(numeric_sub, days, date);

	PG_RETURN_DATUM(result);
}

