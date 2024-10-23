/*-------------------------------------------------------------------------
 *
 * uint8.c
 *	  routines to support unsigned bigint
 *
 * Portions Copyright (c) 1996-2020, Hundsun Technologies Inc.
 * 
 * LightDB add at 2023/11/07 for S202310175128
 * 	support cast (expr as unsigned)
 * 
 *-------------------------------------------------------------------------
 */

#include "postgres.h"
#include "access/hash.h"
#include "libpq/pqformat.h"
#include "nodes/nodeFuncs.h"
#include "catalog/pg_collation.h"
#include "catalog/pg_type.h"
#include "utils/builtins.h"
#include "utils/bytea.h"
#include "utils/lsyscache.h"
#include "utils/memutils.h"
#include "utils/numeric.h"
#include "utils/pg_locale.h"
#include "utils/formatting.h"
#include "mb/pg_wchar.h"
#include "fmgr.h"
#include "miscadmin.h"
#include "common/int.h"


#define PG_GETARG_UINT64(n)	 DatumGetUInt64(PG_GETARG_DATUM(n))


PG_FUNCTION_INFO_V1(lt_numeric2unsigned);

Datum
lt_numeric2unsigned(PG_FUNCTION_ARGS)
{
	Numeric		num = PG_GETARG_NUMERIC(0);

	PG_RETURN_DATUM(lt_numeric_unsigned(num));
}