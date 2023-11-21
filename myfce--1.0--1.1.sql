GRANT USAGE ON SCHEMA mysql TO PUBLIC;

ALTER FUNCTION pg_catalog.find_in_set("any", text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.truncate(smallint, int4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.truncate(integer, int4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.truncate(bigint, int4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.truncate(numeric, int4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.truncate(double precision, int4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.group_concat_transfn(internal, text, text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, bigint) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, float8) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, float4) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.myfce_group_concat_transfn(internal, text, numeric) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.group_concat_finalfn(internal) SET SCHEMA mysql;
ALTER AGGREGATE pg_catalog.group_concat( text,text  ) SET SCHEMA mysql;
ALTER AGGREGATE pg_catalog.group_concat( text,bigint  ) SET SCHEMA mysql;
ALTER AGGREGATE pg_catalog.group_concat( text,float8  ) SET SCHEMA mysql;
ALTER AGGREGATE pg_catalog.group_concat( text,float4  ) SET SCHEMA mysql;
ALTER AGGREGATE pg_catalog.group_concat( text,numeric  ) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,text,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,real,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,float8,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,bigint,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,numeric,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,text,real) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,text,float8) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,text,bigint) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,text,numeric) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,float8,float8) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,float8,bigint) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,float8,numeric) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,bigint,float8) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,bigint,bigint) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,bigint,numeric) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,numeric,float8) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,numeric,bigint) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.if (boolean,numeric,numeric) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.database() SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.locate(text,text,int) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.locate(text,text) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.datediff(timestamp,timestamp) SET SCHEMA mysql;
ALTER FUNCTION pg_catalog.datediff(text,text) SET SCHEMA mysql;
ALTER DOMAIN pg_catalog.longtext SET SCHEMA mysql;

ALTER FUNCTION mysql.find_in_set("any", text) PARALLEL SAFE;
ALTER FUNCTION mysql.truncate(smallint, int4) PARALLEL SAFE;
ALTER FUNCTION mysql.truncate(integer, int4) PARALLEL SAFE;
ALTER FUNCTION mysql.truncate(bigint, int4) PARALLEL SAFE;
ALTER FUNCTION mysql.truncate(numeric, int4) PARALLEL SAFE;
ALTER FUNCTION mysql.truncate(double precision, int4) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,text,text) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,real,text) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,float8,text) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,bigint,text) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,numeric,text) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,text,real) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,text,float8) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,text,bigint) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,text,numeric) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,float8,float8) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,float8,bigint) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,float8,numeric) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,bigint,float8) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,bigint,bigint) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,bigint,numeric) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,numeric,float8) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,numeric,bigint) PARALLEL SAFE;
ALTER FUNCTION mysql.if (boolean,numeric,numeric) PARALLEL SAFE;
ALTER FUNCTION mysql.locate(text,text,int) PARALLEL SAFE;
ALTER FUNCTION mysql.locate(text,text) PARALLEL SAFE;



create function mysql.year(text) returns int4 as $$ begin
return extract(year from $1::date); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.year(timestamptz) returns int4 as $$ begin
return extract(year from $1); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.day(text) returns int2 as $$ begin
return extract(day from $1::date); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.day(timestamptz) returns int4 as $$ begin
return extract(day from $1); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_format(timestamp,text)
returns text  AS 'MODULE_PATHNAME','myfce_date_format' language c STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_format(timestamptz,text)
returns text  AS 'MODULE_PATHNAME','myfce_date_format_timestamptz'  language c STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_format(text,text) returns text  AS $$ begin
  return mysql.date_format($1::timestamptz,$2); end;$$  language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.str_to_date(text,text)
returns timestamp  AS 'MODULE_PATHNAME','myfce_str_to_date' language c STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.from_unixtime(text) returns timestamp as $$ begin
return CASE WHEN cast($1 as bigint ) < 0 THEN NULL ELSE to_timestamp($1) END; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.from_unixtime(int8) returns timestamp as $$ begin
return CASE WHEN $1 < 0 THEN NULL ELSE to_timestamp($1) END; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.from_unixtime(int8,text) returns text as $$ begin
return CASE WHEN $1 < 0 THEN NULL ELSE mysql.date_format(to_timestamp($1),$2) END; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.from_unixtime(text,text) returns text as $$ begin
return CASE WHEN cast($1 as bigint ) < 0 THEN NULL ELSE mysql.date_format(to_timestamp($1),$2) END; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.unix_timestamp() returns int8  as $$ begin
return extract(epoch from statement_timestamp());  end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.unix_timestamp(timestamptz) returns int8  as $$ begin
return extract(epoch from $1);  end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.unix_timestamp(text) returns int8  as $$ begin
return extract(epoch from $1::timestamptz);  end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

CREATE function  mysql.ifnull(anycompatible,anycompatible) RETURNS anycompatible
AS $$ begin return CASE WHEN $1 IS NOT NULL THEN $1 ELSE $2 END; end; $$ LANGUAGE plpgsql PARALLEL SAFE;
CREATE function  mysql.ifnull(text,text) RETURNS text
AS $$ begin return CASE WHEN $1 IS NOT NULL THEN $1 ELSE $2 END; end; $$ LANGUAGE plpgsql PARALLEL SAFE;

create function mysql.date_sub(timestamptz,interval) returns date as $$ begin
return $1::date - $2; end;$$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_sub(text,interval) returns date as $$ begin
return $1::date - $2; end;$$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_add (timestamptz,interval)returns date as $$ begin
return $1::date + $2; end;$$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.date_add(text,interval) returns date as $$ begin
return $1::date + $2; end;$$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create domain mysql.signed as bigint;

create function mysql.dayofweek(timestamptz) returns int4  as $$ begin 
return extract(DOW FROM $1)+1; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.dayofweek(text) returns int4  as $$ begin 
return extract(DOW FROM $1::date)+1; end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.weekofyear(timestamptz) returns int4 as $$ begin 
return extract(week FROM $1); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;
create function mysql.weekofyear(text) returns int4 as $$ begin 
return extract(week FROM $1::date); end; $$ language plpgsql STRICT IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION mysql.compress(text) RETURNS bytea
AS 'MODULE_PATHNAME', 'myfce_zlib_compress' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION mysql.uncompress(bytea) RETURNS text
AS 'MODULE_PATHNAME', 'myfce_zlib_decompress' LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.timestamp_text_ge(timestamp without time zone, text) returns boolean as $$
    select $1 >= $2::timestamp without time zone
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.timestamp_text_le(timestamp without time zone, text) returns boolean as $$
    select $1 <= $2::timestamp without time zone
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.timestamp_text_gt(timestamp without time zone, text) returns boolean as $$
    select $1 > $2::timestamp without time zone
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.timestamp_text_lt(timestamp without time zone, text) returns boolean as $$
    select $1 < $2::timestamp without time zone
$$ language sql STRICT IMMUTABLE PARALLEL SAFE;

CREATE OPERATOR >= (
  LEFTARG   = timestamp without time zone,
  RIGHTARG  = text,
  PROCEDURE = mysql.timestamp_text_ge
);

CREATE OPERATOR <= (
  LEFTARG   = timestamp without time zone,
  RIGHTARG  = text,
  PROCEDURE = mysql.timestamp_text_le
);

CREATE OPERATOR > (
  LEFTARG   = timestamp without time zone,
  RIGHTARG  = text,
  PROCEDURE = mysql.timestamp_text_gt
);

CREATE OPERATOR < (
  LEFTARG   = timestamp without time zone,
  RIGHTARG  = text,
  PROCEDURE = mysql.timestamp_text_lt
);

create function mysql.any_value_transfn(anyelement,anyelement) returns anyelement as $$ begin
   return case when $1 is null then $2 else $1 end;
end;$$ language PLPGSQL IMMUTABLE PARALLEL SAFE;

create function mysql.any_value_finalfn(anyelement) returns anyelement as $$ begin
return $1;
end;$$ language PLPGSQL STRICT IMMUTABLE PARALLEL SAFE;

CREATE AGGREGATE mysql.any_value( anyelement)(
        SFUNC = mysql.any_value_transfn,
        STYPE = anyelement,
        FINALFUNC = mysql.any_value_finalfn
);

CREATE VIEW mysql.dual AS SELECT 'X'::varchar AS dummy;

CREATE FUNCTION mysql.instr(str text, patt text)
RETURNS int
AS 'MODULE_PATHNAME', 'myfce_plvstr_instr2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


CREATE or replace FUNCTION mysql.field(str text, VARIADIC strlist text[])
RETURNS bigint IMMUTABLE AS $$
select case when str is null or strlist is null then 0
            else (select coalesce(min(id), 0) from (select row_number()over() as id, elem.* from unnest(strlist) as elem) as x where elem = str)
       end;
$$ LANGUAGE sql PARALLEL SAFE;  --mysql is not STRICT

CREATE or replace FUNCTION mysql.field(str numeric, VARIADIC strlist numeric[])
RETURNS bigint IMMUTABLE AS $$
    select case when str is null or strlist is null then 0
                else (select coalesce(min(id), 0) from (select row_number()over() as id, elem.* from unnest(strlist) as elem) as x where elem = str)
        end;
$$ LANGUAGE sql PARALLEL SAFE;  --mysql is not STRICT

CREATE or replace FUNCTION mysql.elt(str_pos int, VARIADIC strlist text[])
RETURNS text IMMUTABLE AS $$
    select min(elem) from (select row_number()over() as id, elem.* from unnest(strlist) as elem) as x where id = str_pos;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.strcmp(p1 text, p2 text)
RETURNS int IMMUTABLE AS $$
    select case when p1 > p2 then 1 when p1 = p2 then 0 else -1 end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.log10(p1 numeric)
RETURNS numeric IMMUTABLE AS $$
    select case when p1 <= 0 then null else pg_catalog.log(p1) end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.log10(p1 double precision)
RETURNS double precision IMMUTABLE AS $$
    select case when p1 <= 0 then null else pg_catalog.log(p1) end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.insert(p_source text, p_pos bigint, p_len bigint, p_replacement text)
RETURNS text IMMUTABLE AS $$
    select case when p_source is null or p_pos is null or p_len is null or p_replacement is null then null
                when p_pos <= 0 or p_pos > length(p_source) then p_source
                else pg_catalog.substr(p_source, 1, p_pos - 1)||p_replacement||pg_catalog.substr(p_source, p_pos + p_len)
        end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.lcase(p_source text)
RETURNS text IMMUTABLE AS $$
    select pg_catalog.lower(p_source);
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.ucase(p_source text)
RETURNS text IMMUTABLE AS $$
    select pg_catalog.upper(p_source);
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.space(p_num int)
RETURNS text IMMUTABLE AS $$
    select pg_catalog.repeat(' ', p_num);
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.mid(p_source text, p_pos bigint, p_len bigint)
RETURNS text IMMUTABLE AS $$
    select case when p_len <= 0 then ''
    when p_pos > 0 then pg_catalog.substr(p_source, p_pos, p_len) 
    when p_pos = 0 then ''
    else pg_catalog.substr(p_source, p_pos + length(p_source) + 1, p_len)  end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;


CREATE or replace FUNCTION mysql.to_days(p_date timestamp)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from p_date)/86400)::bigint + 719528;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_days(p_date timestamptz)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from p_date::timestamp)/86400)::bigint + 719528;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_days( p_date text)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from p_date::timestamp)/86400)::bigint + 719528;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_days( p_date text
                                             , p_format text)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from to_timestamp(p_date, p_format))/86400)::bigint + 719528;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_days(p_date bigint)
RETURNS bigint IMMUTABLE AS $$
    begin
        if p_date <= 100
        then
            return null;
        elsif p_date < 1000
        then
            return floor(extract(epoch from to_timestamp('20000'||p_date::text, 'YYYYMMDD'))/86400)::bigint + 719528;
        elsif p_date < 10000
        then
            return floor(extract(epoch from to_timestamp('2000'||p_date::text, 'YYYYMMDD'))/86400)::bigint + 719528;
        elsif p_date < 100000
        then
            return floor(extract(epoch from to_timestamp('0'||p_date::text, 'YYMMDD'))/86400)::bigint + 719528;
        elsif p_date < 1000000
        then
            return floor(extract(epoch from to_timestamp(p_date::text, 'YYMMDD'))/86400)::bigint + 719528;
        elsif p_date < 10000000
        then
            return null;
        elsif p_date > 99991231
        then
            return null;
        else
            return floor(extract(epoch from to_timestamp(p_date::text, 'YYYYMMDD'))/86400)::bigint + 719528;
        end if;
    exception
        when others then
            return null;
    end
$$ LANGUAGE plpgsql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_seconds(p_date timestamp)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from p_date))::bigint + 62167219200;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_seconds(p_date timestamptz)
RETURNS bigint IMMUTABLE AS $$
    SELECT floor(extract(epoch from p_date))::bigint + 62167219200;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.timediff(p_date1 timestamptz, p_date2 timestamptz)
RETURNS interval IMMUTABLE AS $$
    SELECT p_date1 - p_date2;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.time_to_sec(p_time time)
RETURNS int IMMUTABLE AS $$
    select extract(epoch from p_time::time)::int;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.sec_to_time(p_secs int)
RETURNS interval IMMUTABLE AS $$
    select ($1||' '||'second')::interval;  
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.to_base64(p_str text)
RETURNS text IMMUTABLE AS $$
    select encode(p_str::bytea, 'base64'::text);
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.from_base64(p_str text)
RETURNS text IMMUTABLE AS $$
    select convert_from(decode(p_str, 'base64'), 'UTF8');
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.log2(p_num numeric)
RETURNS numeric IMMUTABLE AS $$
    select case when p_num <= 0 then null else log(2, p_num) end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.uuid_to_bin(p_uuid uuid, swap_flag int4 default 0)
RETURNS bytea IMMUTABLE AS $$
    select ('\x'||replace(p_uuid::text, '-', ''))::bytea;
$$ LANGUAGE sql STRICT PARALLEL SAFE;  --mysql is 0x0768A47DD355372B4926EE668B6CB443

CREATE or replace FUNCTION mysql.bin_to_uuid(p_uuid bytea, swap_flag int4 default 0)
RETURNS uuid IMMUTABLE AS $$
    select (replace(p_uuid::text, '\x', ''))::uuid;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.timestampdiff( p_unit text
                                                   , p_ts1  timestamptz
                                                   , p_ts2  timestamptz)
RETURNS bigint IMMUTABLE AS $$
    select (case upper(p_unit)
            when 'MICROSECOND'   then extract(epoch from p_ts2) * 1000000 - extract(epoch from p_ts1) * 1000000
            when 'SECOND'        then extract(epoch from p_ts2) - extract(epoch from p_ts1)
            when 'MINUTE'        then trunc((extract(epoch from p_ts2) - extract(epoch from p_ts1))/60)
            when 'HOUR'          then trunc((extract(epoch from p_ts2) - extract(epoch from p_ts1))/3600)
            when 'DAY'           then extract(DAY from p_ts2 - p_ts1)
            when 'WEEK'          then trunc((extract(DAY from p_ts2 - p_ts1))/7)
            when 'MONTH'         then (select (extract(YEAR from t) * 12 + extract(MONTH from t)) from (SELECT age(p_ts2, p_ts1) as t) as x)
            when 'QUARTER'       then (select trunc((extract(YEAR from t) * 12 + extract(MONTH from t))/3) from (SELECT age(p_ts2, p_ts1) as t) as x)
            when 'YEAR'          then extract(YEAR from age(p_ts2, p_ts1))
            else null
            end)::bigint;
$$ LANGUAGE sql STRICT PARALLEL SAFE;  --p_unit of mysql is MICROSECOND\SECOND\... no quotation marks

CREATE or replace FUNCTION mysql.isnull(text)
RETURNS bool IMMUTABLE AS $$
    select (case when $1 is null then 'true' else 'false' end)::bool;
$$ LANGUAGE sql PARALLEL SAFE;  --the return value of mysql is 0/1 

CREATE or replace FUNCTION mysql.isnull(numeric)
RETURNS bool IMMUTABLE AS $$
    select (case when $1 is null then 'true' else 'false' end)::bool;
$$ LANGUAGE sql PARALLEL SAFE;

CREATE or replace FUNCTION mysql.isnull(timestamptz)
RETURNS bool IMMUTABLE AS $$
    select (case when $1 is null then 'true' else 'false' end)::bool;
$$ LANGUAGE sql PARALLEL SAFE;

CREATE or replace FUNCTION mysql.conv( p_num        text
                                          , p_from_base  int4
                                          , p_to_base    int4)
RETURNS text IMMUTABLE AS $$
    select case when p_from_base = 10 and p_to_base = 16 then upper(to_hex(p_num::bigint)::text)
                when p_from_base = 10 and p_to_base = 2  then ltrim(p_num::bigint::bit(128)::text, '0')
                when p_from_base = 16 and p_to_base = 10 then (select sum(n)::text
                                                                from (select case substr(lower(p_num), n, 1)
                                                                            when 'a' then 10
                                                                            when 'b' then 11
                                                                            when 'c' then 12
                                                                            when 'd' then 13
                                                                            when 'e' then 14
                                                                            when 'f' then 15
                                                                            else substr(lower(p_num), n, 1)::int
                                                                            end * (16 ^ (max(n) over () - n)) as n
                                                                        from generate_series(1, length(p_num)) as n))
                when p_from_base = 16 and p_to_base = 2  then ltrim(('x'||p_num)::varbit(128)::text, '0')
                when p_from_base = 2 and p_to_base = 10  then (select sum(n)::text
                                                                from (select substr(lower(p_num), n, 1)::int
                                                                            * (2 ^ (max(n) over () - n)) as n
                                                                        from generate_series(1, length(p_num)) as n))
                when p_from_base = 2 and p_to_base = 16  then (select string_agg(hex_data, '')
                                                                from (select row_number()over()as id
                                                                            , case substr('000'||p_num, l - row_number()over() * 4 + 4, 4)
                                                                                when '0000' then '0'
                                                                                when '0001' then '1'
                                                                                when '0010' then '2'
                                                                                when '0011' then '3'
                                                                                when '0100' then '4'
                                                                                when '0101' then '5'
                                                                                when '0110' then '6'
                                                                                when '0111' then '7'
                                                                                when '1000' then '8'
                                                                                when '1001' then '9'
                                                                                when '1010' then 'A'
                                                                                when '1011' then 'B'
                                                                                when '1100' then 'C'
                                                                                when '1101' then 'D'
                                                                                when '1110' then 'E'
                                                                                when '1111' then 'F'
                                                                            end as hex_data
                                                                        from (select generate_series(1, ceil(length(p_num) / 4::numeric)) as n, length(p_num) as l)
                                                                        order by id desc))
                else null
        end;
$$ LANGUAGE sql STRICT PARALLEL SAFE;

CREATE or replace FUNCTION mysql.rand_setseed(p_seed int)
RETURNS double precision IMMUTABLE AS $$
    begin
        perform setseed(p_seed/4294967296::float8);
        return 0;
    end;
$$ LANGUAGE plpgsql PARALLEL SAFE;

CREATE or replace FUNCTION mysql.rand(p_seed int default null)
RETURNS double precision AS $$
    select case when p_seed is null then random() else mysql.rand_setseed(p_seed) + random() end;
$$ LANGUAGE sql PARALLEL SAFE;  --when p_seed==null then p_seed=0 in mysql

CREATE or replace FUNCTION mysql.if(check_condition boolean, true_expr bool, false_expr bool)
RETURNS bool IMMUTABLE AS $$
    select case when check_condition then true_expr else false_expr end;
$$ LANGUAGE sql PARALLEL SAFE;  --mysql does not support

CREATE or replace FUNCTION mysql.if(check_condition boolean, true_expr timestamptz, false_expr timestamptz)
RETURNS timestamptz IMMUTABLE AS $$
    select case when check_condition then true_expr else false_expr end;
$$ LANGUAGE sql PARALLEL SAFE;  --mysql does not support
