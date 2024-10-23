DROP OPERATOR IF EXISTS mysql.=(varchar, boolean);

DROP FUNCTION IF EXISTS mysql.varchar_bool_equal(varchar, boolean);

CREATE FUNCTION mysql.text_bool_equal(text, boolean)
    RETURNS boolean
AS 'MODULE_PATHNAME', 'text_bool_equal'
LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR mysql.= (
    LEFTARG    = text,
    RIGHTARG   = boolean,
    PROCEDURE  = mysql.text_bool_equal
);

DROP OPERATOR IF EXISTS mysql.!=(varchar, boolean);

DROP FUNCTION IF EXISTS mysql.varchar_bool_not_equal(varchar, boolean);

CREATE FUNCTION mysql.text_bool_not_equal(text, boolean)
    RETURNS boolean
AS 'MODULE_PATHNAME', 'text_bool_not_equal'
LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR mysql.!= (
    LEFTARG    = text,
    RIGHTARG   = boolean,
    PROCEDURE  = mysql.text_bool_not_equal
);

DROP OPERATOR IF EXISTS mysql.=(varchar, text);

DROP FUNCTION IF EXISTS mysql.varchar_text_equal(varchar, text);

DROP OPERATOR IF EXISTS mysql.!=(varchar,text);

DROP FUNCTION IF EXISTS mysql.varchar_text_not_equal(varchar, text);



--  select STR_TO_DATE(sysdate(), '%Y-%m-%d %H:%i:%s')
create function mysql.str_to_date2(timestamp without time zone, text) returns date as 
$$
    select cast($1 as date);
$$ language sql IMMUTABLE;

create function mysql.str_to_date3(timestamp without time zone, text) returns time as 
$$
    select cast($1 as time);
$$ language sql IMMUTABLE;

create function mysql.str_to_date(timestamp without time zone, text) returns timestamp as 
$$
    select cast($1 as timestamp);
$$ language sql IMMUTABLE;

create function mysql.str_to_date2(date, text) returns date as 
$$
    select $1;
$$ language sql IMMUTABLE;

create function mysql.str_to_date3(date, text) returns time as 
$$
    select '00:00:00'::time;
$$ language sql IMMUTABLE;

create function mysql.str_to_date(date, text) returns timestamp as 
$$
    select cast($1 as timestamp);
$$ language sql IMMUTABLE;

create function mysql.datediff(timestamp, timestamp with time zone) returns int as
$$
    select $1::date - $2::date
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.datediff(timestamp with time zone, timestamp) returns int as
$$
select $1::date - $2::date
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.datediff(timestamp with time zone, timestamp with time zone) returns int as
$$
    select $1::date - $2::date
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.datediff(date, date) returns int as
$$
select $1 - $2
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

-- generate random UUID. return a utf8 string of five hexadecimal numbers in aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee format.
create function mysql.uuid() returns text as
$$
select  pg_catalog.gen_random_uuid()::text;
$$ language sql STRICT VOLATILE PARALLEL SAFE;
COMMENT ON FUNCTION mysql.uuid() IS 'generate random UUID. return a utf8 string of five hexadecimal numbers in aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee format.';

create or replace function mysql.hex(data bytea) returns text as 
$$
    SELECT encode(data, 'hex');
$$language sql IMMUTABLE;

create or replace function mysql.unhex(data varchar) returns bytea as 
$$
    SELECT decode(data, 'hex');
$$language sql IMMUTABLE;

-- crypto
create or replace function mysql.aes_encrypt(data bytea, key bytea) returns bytea as 
$$
    select encrypt(data,key, 'aes-ecb');
$$language sql IMMUTABLE;

create or replace function mysql.aes_encrypt(data varchar, key varchar) returns bytea as 
$$
    select encrypt(cast(data as bytea) , cast(key as bytea), 'aes-ecb');
$$language sql IMMUTABLE;

create or replace function mysql.aes_decrypt(data bytea, key bytea) returns bytea as 
$$
    select decrypt(data,key, 'aes-ecb');
$$language sql IMMUTABLE;

create or replace function mysql.aes_decrypt(data varchar, key varchar) returns bytea as 
$$
    select decrypt(cast(data as bytea) , cast(key as bytea), 'aes-ecb');
$$language sql IMMUTABLE;

create or replace function mysql.aes_decrypt(data bytea, key varchar) returns bytea as 
$$
    select decrypt(data , cast(key as bytea), 'aes-ecb');
$$language sql IMMUTABLE;

CREATE OR REPLACE FUNCTION mysql.substring_index(varchar, varchar, integer)
RETURNS varchar AS $$
DECLARE
    tokens varchar[];
    length integer ;
    indexnum integer;
BEGIN
    if $2 = '' THEN
        RETURN '';
    END IF;    
    tokens := pg_catalog.string_to_array($1, $2);
    length := pg_catalog.array_upper(tokens, 1);
    indexnum := length - ($3 * -1) + 1;
    IF $3 >= 0 THEN
        RETURN pg_catalog.array_to_string(tokens[1:$3], $2);
    ELSE
        RETURN pg_catalog.array_to_string(tokens[indexnum:length], $2);
    END IF;
END;
$$ IMMUTABLE STRICT PARALLEL SAFE LANGUAGE PLPGSQL;

CREATE FUNCTION mysql.quarter(timestamp)
RETURNS int
AS 'MODULE_PATHNAME', 'quarter_ts'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

create function mysql.format(numeric, int) returns text as 
$$
    select round($1,if($2<=0,0,$2))::text;
$$language sql IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION mysql.timestampdiff( p_unit text
, p_ts1  timestamptz
, p_ts2  text)
    RETURNS bigint IMMUTABLE AS $$
DECLARE
    result bigint;
BEGIN
    CASE upper(p_unit)
        WHEN 'MICROSECOND' THEN
            result := extract(epoch from p_ts2::timestamptz) * 1000000 - extract(epoch from p_ts1) * 1000000;
        WHEN 'SECOND' THEN
            result := extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1);
        WHEN 'MINUTE' THEN
            result := trunc((extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1))/60);
        WHEN 'HOUR' THEN
            result := trunc((extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1))/3600);
        WHEN 'DAY' THEN
            result := extract(DAY from p_ts2::timestamptz - p_ts1);
        WHEN 'WEEK' THEN
            result := trunc((extract(DAY from p_ts2::timestamptz - p_ts1))/7);
        WHEN 'MONTH' THEN
            result := (select (extract(YEAR from t) * 12 + extract(MONTH from t)) from (SELECT age(p_ts2::timestamptz, p_ts1) as t) as x);
        WHEN 'QUARTER' THEN
            result := (select trunc((extract(YEAR from t) * 12 + extract(MONTH from t))/3) from (SELECT age(p_ts2::timestamptz, p_ts1) as t) as x);
        WHEN 'YEAR' THEN
            result := extract(YEAR from age(p_ts2::timestamptz, p_ts1));
        ELSE
            RAISE EXCEPTION 'Invalid time unit: %', p_unit;
    END CASE;
    RETURN result;
END;
$$ LANGUAGE plpgsql STRICT PARALLEL SAFE;

CREATE FUNCTION mysql.timestampdiff( p_unit text
, p_ts1  text
, p_ts2  timestamptz)
    RETURNS bigint IMMUTABLE AS $$
DECLARE
    result bigint;
BEGIN
    CASE upper(p_unit)
        WHEN 'MICROSECOND' THEN
            result := extract(epoch from p_ts2) * 1000000 - extract(epoch from p_ts1::timestamptz) * 1000000;
        WHEN 'SECOND' THEN
            result := extract(epoch from p_ts2) - extract(epoch from p_ts1::timestamptz);
        WHEN 'MINUTE' THEN
            result := trunc((extract(epoch from p_ts2) - extract(epoch from p_ts1::timestamptz))/60);
        WHEN 'HOUR' THEN
            result := trunc((extract(epoch from p_ts2) - extract(epoch from p_ts1::timestamptz))/3600);
        WHEN 'DAY' THEN
            result := extract(DAY from p_ts2 - p_ts1::timestamptz);
        WHEN 'WEEK' THEN
            result := trunc((extract(DAY from p_ts2 - p_ts1::timestamptz))/7);
        WHEN 'MONTH' THEN
            result := (select (extract(YEAR from t) * 12 + extract(MONTH from t)) from (SELECT age(p_ts2, p_ts1::timestamptz) as t) as x);
        WHEN 'QUARTER' THEN
            result := (select trunc((extract(YEAR from t) * 12 + extract(MONTH from t))/3) from (SELECT age(p_ts2, p_ts1::timestamptz) as t) as x);
        WHEN 'YEAR' THEN
            result := extract(YEAR from age(p_ts2, p_ts1::timestamptz));
        ELSE
            RAISE EXCEPTION 'Invalid time unit: %', p_unit;
    END CASE;
    RETURN result;
END;
$$ LANGUAGE plpgsql STRICT PARALLEL SAFE;

CREATE FUNCTION mysql.timestampdiff( p_unit text
, p_ts1  text
, p_ts2  text)
    RETURNS bigint IMMUTABLE AS $$
DECLARE
    result bigint;
BEGIN
    CASE upper(p_unit)
        WHEN 'MICROSECOND' THEN
            result := extract(epoch from p_ts2::timestamptz) * 1000000 - extract(epoch from p_ts1::timestamptz) * 1000000;
        WHEN 'SECOND' THEN
            result := extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1::timestamptz);
        WHEN 'MINUTE' THEN
            result := trunc((extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1::timestamptz))/60);
        WHEN 'HOUR' THEN
            result := trunc((extract(epoch from p_ts2::timestamptz) - extract(epoch from p_ts1::timestamptz))/3600);
        WHEN 'DAY' THEN
            result := extract(DAY from p_ts2::timestamptz - p_ts1::timestamptz);
        WHEN 'WEEK' THEN
            result := trunc((extract(DAY from p_ts2::timestamptz - p_ts1::timestamptz))/7);
        WHEN 'MONTH' THEN
            result := (select (extract(YEAR from t) * 12 + extract(MONTH from t)) from (SELECT age(p_ts2::timestamptz, p_ts1::timestamptz) as t) as x);
        WHEN 'QUARTER' THEN
            result := (select trunc((extract(YEAR from t) * 12 + extract(MONTH from t))/3) from (SELECT age(p_ts2::timestamptz, p_ts1::timestamptz) as t) as x);
        WHEN 'YEAR' THEN
            result := extract(YEAR from age(p_ts2::timestamptz, p_ts1::timestamptz));
        ELSE
            RAISE EXCEPTION 'Invalid time unit: %', p_unit;
    END CASE;
    RETURN result;
END;
$$ LANGUAGE plpgsql STRICT PARALLEL SAFE;

CREATE FUNCTION mysql.curdate() RETURNS date IMMUTABLE AS $$
    select current_date();
$$ LANGUAGE sql STRICT PARALLEL SAFE;


-- LightDB add at 2023/11/07 for S202310175128
CREATE FUNCTION mysql.numeric2unsigned(numeric)
RETURNS numeric
AS 'MODULE_PATHNAME','lt_numeric2unsigned'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

--- fix OID begin ---
DROP TYPE mysql.longtext cascade;
select pg_catalog.lt_set_internal_next_oid('mysql',0,x'9f50'::integer);
CREATE TYPE mysql.longtext;
select pg_catalog.lt_set_internal_next_oid('mysql',1,x'9f60'::integer);
CREATE domain mysql.longtext as text;

DROP TYPE mysql.signed cascade;
select pg_catalog.lt_set_internal_next_oid('mysql',0,x'9f51'::integer);
CREATE TYPE mysql.signed;
select pg_catalog.lt_set_internal_next_oid('mysql',1,x'9f61'::integer);
create domain mysql.signed as bigint;

select pg_catalog.lt_set_internal_next_oid('oracle',0,0);
select pg_catalog.lt_set_internal_next_oid('oracle',1,0);
--- fix OID end ---

CREATE FUNCTION mysql.last_day(value date)
RETURNS date
AS 'MODULE_PATHNAME', 'my_last_day'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
COMMENT ON FUNCTION mysql.last_day(date) IS 'returns last day of the month based on a date value';


CREATE FUNCTION mysql.last_day(value text)
RETURNS date AS
$$
    SELECT mysql.last_day(cast(value as date));
$$
LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;


-- { LightDB add for  202311014178
CREATE FUNCTION mysql.add_days_to_date(date, bigint)
    RETURNS bigint
AS 'MODULE_PATHNAME','lt_myfce_date_add_days'
LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(bigint, date)
    RETURNS bigint AS $$
SELECT mysql.add_days_to_date($2, $1);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (date, bigint)
    RETURNS bigint
AS 'MODULE_PATHNAME','lt_myfce_date_sub_days'
LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (bigint, date)
    RETURNS bigint
AS 'MODULE_PATHNAME','lt_myfce_days_sub_date'
    LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(date,integer)
    RETURNS bigint AS $$
SELECT mysql.add_days_to_date($1, $2::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(integer,date)
    RETURNS bigint AS $$
SELECT mysql.add_days_to_date($2, $1::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (date, integer)
    RETURNS bigint AS $$
SELECT mysql.subtract($1, $2::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (integer, date)
    RETURNS bigint AS $$
SELECT mysql.subtract($1::bigint, $2);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(date, smallint)
    RETURNS bigint AS $$
SELECT mysql.add_days_to_date($1, $2::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(smallint, date)
    RETURNS bigint AS $$
SELECT mysql.add_days_to_date($2, $1::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (date, smallint)
    RETURNS bigint AS $$
SELECT mysql.subtract($1, $2::bigint);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (smallint, date)
    RETURNS bigint AS $$
SELECT mysql.subtract($1::bigint, $2);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.add_days_to_date(date,numeric)
    RETURNS numeric
AS 'MODULE_PATHNAME','lt_myfce_date_add_days_numeric'
LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION mysql.add_days_to_date(numeric, date)
    RETURNS numeric AS $$
SELECT mysql.add_days_to_date($2, $1);
$$ LANGUAGE SQL STRICT IMMUTABLE PARALLEL SAFE ;

CREATE FUNCTION mysql.subtract (date, numeric)
    RETURNS numeric
AS 'MODULE_PATHNAME','lt_myfce_date_sub_days_numeric'
LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION mysql.subtract (numeric, date)
    RETURNS numeric
AS 'MODULE_PATHNAME','lt_myfce_days_sub_date_numeric'
    LANGUAGE 'c' STRICT IMMUTABLE PARALLEL SAFE;

CREATE OPERATOR mysql.+ (
    LEFTARG   = date,
    RIGHTARG  = bigint,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.+ (
    LEFTARG   = bigint,
    RIGHTARG  = date,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = date,
    RIGHTARG  = bigint,
    PROCEDURE = mysql.subtract
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = bigint,
    RIGHTARG  = date,
    PROCEDURE = mysql.subtract
    );

CREATE OPERATOR mysql.+ (
    LEFTARG   = date,
    RIGHTARG  = integer,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.+ (
    LEFTARG   = integer,
    RIGHTARG  = date,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = date,
    RIGHTARG  = integer,
    PROCEDURE = mysql.subtract
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = integer,
    RIGHTARG  = date,
    PROCEDURE = mysql.subtract
    );

CREATE OPERATOR mysql.+ (
    LEFTARG   = date,
    RIGHTARG  = smallint,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.+ (
    LEFTARG   = smallint,
    RIGHTARG  = date,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = date,
    RIGHTARG  = smallint,
    PROCEDURE = mysql.subtract
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = smallint,
    RIGHTARG  = date,
    PROCEDURE = mysql.subtract
    );

CREATE OPERATOR mysql.+ (
    LEFTARG   = date,
    RIGHTARG  = numeric,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.+ (
    LEFTARG   = numeric,
    RIGHTARG  = date,
    PROCEDURE = mysql.add_days_to_date
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = date,
    RIGHTARG  = numeric,
    PROCEDURE = mysql.subtract
    );
CREATE OPERATOR mysql.- (
    LEFTARG   = numeric,
    RIGHTARG  = date,
    PROCEDURE = mysql.subtract
    );

create function mysql.datediff(date, numeric) returns int as
$$
select  mysql.datediff($1,  pg_catalog.trunc($2)::text::date);
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.datediff(numeric, date) returns int as
$$
select  mysql.datediff(pg_catalog.trunc($1)::text::date,  $2);
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.datediff(numeric, numeric) returns int as
$$
select  mysql.datediff(pg_catalog.trunc($1)::text::date,  pg_catalog.trunc($2)::text::date);
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

-- }
