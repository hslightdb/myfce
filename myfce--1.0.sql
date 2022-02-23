/* contrib/myfce/myfce--1.0.sql */

-- complain if script is sourced in ltsql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION myfce" to load this file. \quit

/* ***********************************************
 * function For compatibility with Mysql
 * *********************************************** */

CREATE FUNCTION pg_catalog.find_in_set("any", text)
 RETURNS int
 LANGUAGE C STRICT IMMUTABLE
AS 'MODULE_PATHNAME','myfce_find_in_set'
;

CREATE FUNCTION pg_catalog.truncate(smallint, int4)
 RETURNS integer
AS $function$ SELECT pg_catalog.trunc($1::numeric, $2) $function$
LANGUAGE sql STRICT IMMUTABLE;

CREATE FUNCTION pg_catalog.truncate(integer, int4)
 RETURNS integer
AS $$ SELECT pg_catalog.trunc($1::numeric, $2) $$
LANGUAGE sql STRICT IMMUTABLE;


CREATE FUNCTION pg_catalog.truncate(bigint, int4)
 RETURNS bigint
AS $$ SELECT pg_catalog.trunc($1::numeric, $2) $$
LANGUAGE sql STRICT IMMUTABLE;


CREATE FUNCTION pg_catalog.truncate(numeric, int4)
 RETURNS numeric
AS $$ select pg_catalog.trunc($1::numeric,$2) $$
LANGUAGE sql STRICT IMMUTABLE;

CREATE  FUNCTION pg_catalog.truncate(double precision, int4)
 RETURNS double precision
AS $$ SELECT pg_catalog.trunc($1::numeric,$2) $$
LANGUAGE sql STRICT IMMUTABLE;


CREATE FUNCTION pg_catalog.group_concat_transfn(internal, text, text)
    RETURNS internal
AS 'MODULE_PATHNAME','myfce_group_concat_transfn'
LANGUAGE C IMMUTABLE;

CREATE FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, bigint)
    RETURNS internal
AS 'MODULE_PATHNAME','myfce_group_concat_transfn_bigint'
LANGUAGE C IMMUTABLE;

CREATE FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, float8)
    RETURNS internal
AS 'MODULE_PATHNAME','myfce_group_concat_transfn_float8'
LANGUAGE C IMMUTABLE;

CREATE FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, float4)
    RETURNS internal
AS 'MODULE_PATHNAME','myfce_group_concat_transfn_float4'
LANGUAGE C IMMUTABLE;

CREATE FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, numeric)
    RETURNS internal
AS 'MODULE_PATHNAME','myfce_group_concat_transfn_numeric'
LANGUAGE C IMMUTABLE;

CREATE FUNCTION pg_catalog.group_concat_finalfn(internal)
    RETURNS text
AS 'MODULE_PATHNAME','myfce_group_concat_finalfn'
LANGUAGE C IMMUTABLE;


CREATE AGGREGATE pg_catalog.group_concat( text,text  )(
        SFUNC = group_concat_transfn,
        STYPE = internal,
        FINALFUNC = group_concat_finalfn
);

CREATE AGGREGATE pg_catalog.group_concat( text,bigint  )(
        SFUNC = myfce_group_concat_transfn,
        STYPE = internal,
        FINALFUNC = group_concat_finalfn
);

CREATE AGGREGATE pg_catalog.group_concat( text,float8  )(
        SFUNC = myfce_group_concat_transfn,
        STYPE = internal,
        FINALFUNC = group_concat_finalfn
);

CREATE AGGREGATE pg_catalog.group_concat( text,float4  )(
        SFUNC = myfce_group_concat_transfn,
        STYPE = internal,
        FINALFUNC = group_concat_finalfn
);

CREATE AGGREGATE pg_catalog.group_concat( text,numeric  )(
        SFUNC = myfce_group_concat_transfn,
        STYPE = internal,
        FINALFUNC = group_concat_finalfn
);

create function pg_catalog.if (boolean,text,text) returns text as $$ select case when $1 then $2 else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,real,text) returns text as $$ select case when $1 then $2::text else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,float8,text) returns text as $$ select case when $1 then $2::text else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,bigint,text) returns text as $$ select case when $1 then $2::text else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,numeric,text) returns text as $$ select case when $1 then $2::text else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,text,real) returns text as $$ select case when $1 then $2 else $3::text end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,text,float8) returns text as $$ select case when $1 then $2 else $3::text end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,text,bigint) returns text as $$ select case when $1 then $2 else $3::text end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,text,numeric) returns text as $$ select case when $1 then $2 else $3::text end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,float8,float8) returns numeric as $$ select case when $1 then $2::numeric else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,float8,bigint) returns numeric as $$ select case when $1 then $2::numeric else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,float8,numeric) returns numeric as $$ select case when $1 then $2::numeric else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,bigint,float8) returns numeric as $$ select case when $1 then $2::numeric else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,bigint,bigint) returns numeric as $$ select case when $1 then $2::numeric else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,bigint,numeric) returns numeric as $$ select case when $1 then $2::numeric else $3 end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,numeric,float8) returns numeric as $$ select case when $1 then $2 else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,numeric,bigint) returns numeric as $$ select case when $1 then $2 else $3::numeric end $$ language sql IMMUTABLE;
create function pg_catalog.if (boolean,numeric,numeric) returns numeric as $$ select case when $1 then $2 else $3 end $$ language sql IMMUTABLE;


create function pg_catalog.database() returns text as  $$ select current_schema() $$ language sql;


create function pg_catalog.locate(text,text,int) returns int as  $$
declare pos integer;
begin
	if $3 <= 0 then
		return 0;
end if;
select into pos position($1 in substring($2 from $3));
if pos = 0 then
		return 0;
end if;
return pos + $3-1;
end;
$$
language PLPGSQL STRICT IMMUTABLE;



create function pg_catalog.locate(text,text) returns int as  $$ select position($1 in $2) $$ language sql STRICT IMMUTABLE;


create function pg_catalog.datediff(timestamp,timestamp) returns int as $$ select  $1::date - $2::date $$ language sql STRICT IMMUTABLE;

create function pg_catalog.datediff(text,text) returns int as $$ select  $1::date - $2::date $$ language sql STRICT IMMUTABLE;

CREATE domain  pg_catalog.longtext as text;

/* ***********************************************
 * -- can't overwrite PostgreSQL functions!!!!
 * *********************************************** */
CREATE SCHEMA mysql;
