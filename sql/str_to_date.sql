--
-- test mysql str_to_date
--

-- check lightdb syntax compatible mode
create database test_oracle_db with lightdb_syntax_compatible_type 'oracle';
\c test_oracle_db;

-- set date style
-- reference: https://www.postgresql.org/docs/current/datatype-datetime.html#DATATYPE-DATETIME-OUTPUT
set DateStyle to ISO;
set DateStyle to YMD;
show DateStyle;

create function str_to_date(text,text) returns date
as $$ select cast('2021-04-22' as date) $$ language sql IMMUTABLE;

select str_to_date('2022-01-01', '%Y-%m-%d');

create database test_postgres_db with lightdb_syntax_compatible_type 'off';
\c test_postgres_db;

-- set date style
set DateStyle to ISO;
set DateStyle to YMD;
show DateStyle;

create function str_to_date(text,text) returns time
as $$ select cast('10:20:30' as time) $$ language sql IMMUTABLE;

select str_to_date('2022-01-01', '%Y-%m-%d');
drop function str_to_date;

\c test_mysql_myfce;
drop database test_oracle_db;
drop database test_postgres_db;

-- set date style
set DateStyle to ISO;
set DateStyle to YMD;
show DateStyle;
-- set interval style to postgres, has four value(sql_standard,postgres,postgres_verbose,iso_8601)
set intervalstyle to postgres;
show intervalstyle;

-- check mysql schema
create schema google;
create function google.str_to_date(text,text) returns date
as $$ select cast('2021-04-22' as date) $$ language sql IMMUTABLE;
select google.str_to_date('2022-01-01', '%Y-%m-%d');
create function google.STR_TO_DAT(int) returns date
as $$ select cast('2021-04-22' as date) $$ language sql IMMUTABLE;
select google.str_to_dat(2023);
drop function google.str_to_date;
drop function google.STR_TO_DAT;
drop schema google;

-- ban str_to_date format use bind variable
prepare cacheplan1(text) as select str_to_date('11:30:00',$1);
prepare cacheplan2(text) as select mysql.str_to_date('11:30:00',$1);
prepare cacheplan3(text,text) as select str_to_date($1,$2);
prepare cacheplan4(int) as select str_to_date('11:30:00',$1);
prepare cacheplan5(text) as select str_to_date($1,'%Y-%m-%d %H:%i:%s');
prepare cacheplan6(text) as select mysql.str_to_date($1,$2);

-- test str_to_date format
select str_to_date('09:00:00', '%h:%i:%s');
select str_to_date('2022-05-26 11:30:00','%Y-%m-%d');
select str_to_date('2022-05-26 11:30:00','%Y-%m-%d %H:%i:%s');
select str_to_date('09:00:00', '%h:%i:%s') as a;
select str_to_date('2022-05-26 11:30:00','%Y-%m-%d') as a;
select str_to_date('2022-05-26 11:30:00','%Y-%m-%d %H:%i:%s') as a;
SELECT STR_TO_DATE('a09:30:17','a%h:%i:%s');

-- test return datetime
select str_to_date('2022-05-26 11:30:59','%Y-%m-%d %H:%i:%s');
select str_to_date('2022-05-26 23:00:00','%Y-%m-%d %H:%i:%s');
select str_to_date('2022,5,27 10,40,10','%Y,%m,%d %h,%i,%s');
select str_to_date('20220525 1130','%Y%m%d %h%i');
SELECT STR_TO_DATE('04/11/2022 13:30','%d/%m/%Y %H:%i');
SELECT STR_TO_DATE('Nov 05 2022 02:30 PM','%b %d %Y %h:%i %p');
SELECT STR_TO_DATE('2022-11-06 17:29:30','%Y-%m-%d %T');
SELECT STR_TO_DATE('Monday 7th November 2022 13:45:30','%W %D %M %Y %T');
SELECT STR_TO_DATE('2022,11,10 12,12,12', '%Y,%m,%d %h,%i,%s');
SELECT STR_TO_DATE('2022-12-11 11:12:26','%Y-%m-%d %h:%i:%s');
SELECT STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s');
SELECT STR_TO_DATE('May 1, 2013','%M %d,%Y,%h:%i:%s');
SELECT STR_TO_DATE('2022-12-11','%Y-%m-%d %H:%i:%s');

-- test return date
select str_to_date('2022-05-26','%Y-%m-%d');
select str_to_date('2022-05-26 11:00:00','%Y-%m-%d');
select str_to_date('August,5,2022', '%M,%e,%Y');
select str_to_date('2022,5,27 10,40,10','%Y,%m,%d');
select str_to_date('20220525 1130','%Y%m%d');
select str_to_date('20220525','%Y%m%d');
SELECT STR_TO_DATE('25,5,2022','%d,%m,%Y');
SELECT STR_TO_DATE('August 10 2022', '%M %d %Y');
SELECT STR_TO_DATE('August,5,2022', '%M,%e,%Y');
SELECT STR_TO_DATE('Monday, August 14, 2022', '%W,%M %e, %Y');
SELECT STR_TO_DATE('2022/11/01','%Y/%m/%d');
SELECT STR_TO_DATE('03/11/2022','%e/%c/%Y');
SELECT STR_TO_DATE('25,5,2022 extra characters','%d,%m,%Y');
SELECT STR_TO_DATE('November,8,2022', '%M,%e,%Y');
SELECT STR_TO_DATE('Wednesday November 09 2022', '%W %M %e %Y');
SELECT str_to_date('01,05,2013','%d,%m,%Y');
SELECT str_to_date('May 1, 2013','%M %d,%Y');
SELECT str_to_date('04/30/2004', '%m/%d/%Y');
SELECT STR_TO_DATE('2022-12-11 11:12:26','%Y-%m-%d');

-- test return date in sql_mode no_zero_date
set lightdb_sql_mode to 'no_zero_date';
show lightdb_sql_mode;
SELECT str_to_date('9','%d');
SELECT str_to_date('9','%m');
SELECT str_to_date('1999','%Y%d');
SELECT str_to_date('1999','%Y');
select str_to_date('August,5', '%M,%e,%Y');
select str_to_date('August,5', '%M,%e');
select str_to_date('2022,5,27 10,40,10','%Y,%d');
SELECT STR_TO_DATE('03/11/2022','%e/%c/');
SELECT str_to_date('May 1, 2013','%M %d');
SELECT STR_TO_DATE('Wednesday November 09 2022', '%W %M %e');
SELECT STR_TO_DATE('25,5,2022 extra characters','%d,%m');
SELECT STR_TO_DATE('2022-12-11 11:12:26','%Y-%m');

-- test return date in sql_mode with no no_zero_date, result is different from mysql
set lightdb_sql_mode to '';
show lightdb_sql_mode;
SELECT str_to_date('9','%m');   
SELECT str_to_date('1999','%Y%d');
SELECT str_to_date('1999','%Y');    -- pg return 1999-01-01, mysql return 1999-00-00

-- test return time
select str_to_date('09:00:59', '%h:%i:%s');
SELECT STR_TO_DATE('09:30:17a','%h:%i:%s');
select str_to_date('11:30:00 2022-05-26','%H:%i:%s');
select str_to_date('10,40,10', '%h,%i,%s');
select str_to_date('10,40,50', '%h,%i,%s');
SELECT STR_TO_DATE('11:12:26','%h:%i:%s');
SELECT STR_TO_DATE('13','%H');
SELECT STR_TO_DATE('9','%h');
SELECT STR_TO_DATE('9','%i');
SELECT STR_TO_DATE('9','%s');

-- return error in pg, return null in mysql
set lightdb_sql_mode to 'no_zero_date';
show lightdb_sql_mode;
SELECT str_to_date('13','%m');
SELECT str_to_date('32','%d');
SELECT STR_TO_DATE('61','%s');
SELECT STR_TO_DATE('25','%H');
SELECT STR_TO_DATE('61','%i');
set lightdb_sql_mode to '';
show lightdb_sql_mode;
SELECT str_to_date('13','%m');
SELECT str_to_date('32','%d');
SELECT STR_TO_DATE('61','%s');
SELECT STR_TO_DATE('25','%H');
SELECT STR_TO_DATE('61','%i');

-- test return null in any sql_mode
SELECT str_to_date(null ,'%Y-%m-%d');


-- test nest function call
select date_part('year', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select date_part('month', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select date_part('day', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select date_part('hour', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select date_part('year', str_to_date('2022,5,27', '%Y,%m,%d'));
select date_part('month', str_to_date('2022,5,27', '%Y,%m,%d'));
select date_part('day', str_to_date('2022,5,27', '%Y,%m,%d'));
select date_part('hour', str_to_date('10,40,30', '%h,%i,%s'));
select date_part('minute', str_to_date('10,40,30', '%h,%i,%s'));
select date_part('second', str_to_date('10,40,30', '%h,%i,%s'));
select age(str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'), str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select age(str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'), str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s')) + interval 1 hour;
select age(timestamp '2022-10-27 20:21:23', str_to_date('2022,5,27 11,00,00', '%Y,%m,%d %h,%i,%s'));
select date_trunc('hour', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select extract(quarter from str_to_date('2001-02-16 10:38:40', '%Y-%m-%d %h:%i:%s'));
select extract(hour from str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
select extract(minute from str_to_date('09:00:59', '%h:%i:%s'));
select extract(second from str_to_date('09:00:59', '%h:%i:%s'));
select isfinite(str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));
SELECT DATEDIFF(str_to_date('2007-12-31 3:59:59', '%Y-%m-%d %h:%i:%s'),'2007-12-30');
select timediff(str_to_date('2000-01-01 10:00:00', '%Y-%m-%d %h:%i:%s'), '2000-01-01 00:00:00');
select cast(str_to_date('2007-12-31 3:59:59', '%Y-%m-%d %h:%i:%s') as time);
select cast(str_to_date('2007-12-31 3:59:59', '%Y-%m-%d %h:%i:%s') as date);
select date_part('yea', str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s'));  -- fail
select extract(year from str_to_date('09:00:59', '%h:%i:%s'));  -- fail

CREATE FUNCTION func_date(v DATE) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

select func_date(str_to_date('04/30/2004', '%m/%d/%Y'));


CREATE FUNCTION func_time(v TIME) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

select func_time(STR_TO_DATE('12:12:26','%H:%i:%s'));


CREATE FUNCTION func_datetime(v datetime) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

select func_datetime(STR_TO_DATE('May 1, 2013,9:5:6','%M %d,%Y,%h:%i:%s'));
drop function func_date;
drop function func_time;
drop function func_datetime;

-- test str_to_date in procedure
CREATE FUNCTION func_to_date(v text) RETURNS date AS
$$
	select str_to_date($1, '%Y-%m-%d')
$$ LANGUAGE SQL;

select func_to_date('2021-05-09');
drop function func_to_date;

-- test interval with str_to_date
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') + interval 1 year;
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') - interval 1 year;
select str_to_date('2022,12,27 10,40,30', '%Y,%m,%d %h,%i,%s') + interval 1 month;
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') - interval 1 month;
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') + interval 1 hour;
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') - interval 1 hour;
select str_to_date('25,5,2022','%d,%m,%Y') + interval 1 hour;
select str_to_date('25,5,2022','%d,%m,%Y') - interval 1 hour;
select str_to_date('25,5,2022','%d,%m,%Y') + interval 1 day;
select str_to_date('25,5,2022','%d,%m,%Y') - interval 1 day;
select str_to_date('09:00:59', '%h:%i:%s') + interval 1 hour;
select str_to_date('09:00:59', '%h:%i:%s') - interval 1 hour;
select str_to_date('09:00:59', '%h:%i:%s') + interval 1 hour + interval 1 hour;
select str_to_date('09:00:59', '%h:%i:%s') - interval 1 hour - interval 1 hour;
select str_to_date('12:00:00', '%H:%i:%s') + interval 12 hour;
select str_to_date('12:00:00', '%H:%i:%s') - interval 12 hour;

-- postgres and mysql are different
select str_to_date('2022-05-26 11:30:00','%Y-%m-%d') + integer '1';   -- fail in mysql
SELECT str_to_date('01,5,2013','%d,%m,%Y') + 1;    -- in mysql return an integer like 20130502, but in postgres return a date
SELECT STR_TO_DATE('11:12:26','%h:%i:%s') + 1;     -- in mysql return an integer like 111227, fail in postgres
SELECT STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s') + 1;  -- fail in postgres, in mysql return an integer like 20221211141227
select str_to_date('25,5,2022','%d,%m,%Y') + time '03:00';  -- in postgres return a datetime like 2022-05-25 03:00:00, in mysql return an integer like 20250525
select str_to_date('2022-05-26','%Y-%m-%d') + str_to_date('09:00:00', '%h:%i:%s');
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') + interval '1 hour';  -- in mysql, same to: interval 1 hour
select str_to_date('2022,5,27 10,40,30', '%Y,%m,%d %h,%i,%s') - interval '1 hour';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 years';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 month';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 day';
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s') + interval '2 hour';
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s') + interval '2 minute';
SELECT mysql.STR_TO_DATE('10:12:26','%h:%i:%s') + interval '2 SECOND';
SELECT mysql.STR_TO_DATE('10:12:26','%h:%i:%s') + interval '2';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2';
SELECT mysql.STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s') +interval '2';
select str_to_date('25,6,2022','%d,%m,%Y') - str_to_date('20,5,2022','%d,%m,%Y');
