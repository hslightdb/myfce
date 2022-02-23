
#include<stdint.h>
#include "postgres.h"
#include "funcapi.h"
#include "utils/builtins.h"
#include "lib/stringinfo.h"
#include "fmgr.h"
#include "utils/formatting.h"
#include "utils/numeric.h"
#include "utils/lsyscache.h"


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
