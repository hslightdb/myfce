drop DATABASE if exists test_mysql;
CREATE DATABASE test_mysql with lightdb_syntax_compatible_type mysql;
\c test_mysql
set DateStyle to ISO;
set DateStyle to YMD;
show DateStyle;
CREATE EXTENSION IF NOT EXISTS myfce;
--RETURN DATE
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y');
SELECT mysql.str_to_date('May 1, 2013','%M %d,%Y');
SELECT mysql.str_to_date('04/30/2004', '%m/%d/%Y');
SELECT mysql.str_to_date('9','%m');
SELECT mysql.str_to_date('13','%m');
SELECT mysql.str_to_date('9','%d');
SELECT mysql.str_to_date('32','%d');
SELECT mysql.str_to_date('9','%Y'); --2009-00-00
SELECT mysql.str_to_date('1999','%Y');
SELECT mysql.STR_TO_DATE('2022-12-11 11:12:26','%Y-%m-%d');
SELECT mysql.STR_TO_DATE('01,5,2013','%h:%i:%s'); --error

--RETURN datetime
SELECT mysql.STR_TO_DATE('May 1, 2013','%M %d,%Y,%h:%i:%s');
SELECT mysql.STR_TO_DATE('2022-12-11 11:12:26','%Y-%m-%d %h:%i:%s');
SELECT mysql.STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s');
SELECT mysql.STR_TO_DATE('2022-12-11','%Y-%m-%d %H:%i:%s');
SELECT mysql.STR_TO_DATE('11:12:26','%Y-%m-%d %h:%i:%s'); --error
SELECT mysql.STR_TO_DATE('Nov 05 2022 02:30 PM','%b %d %Y %h:%i %p');
--RETURN TIME
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s');
SELECT mysql.STR_TO_DATE('01-5-2013','%h-%i-%s'); --error
SELECT mysql.STR_TO_DATE('2013-5-2','%h-%i-%s'); --error
SELECT mysql.STR_TO_DATE('9','%s');
SELECT mysql.STR_TO_DATE('61','%s');
SELECT mysql.STR_TO_DATE('9','%h');
SELECT mysql.STR_TO_DATE('13','%h');
SELECT mysql.STR_TO_DATE('13','%H');
SELECT mysql.STR_TO_DATE('25','%H');
SELECT mysql.STR_TO_DATE('9','%i');
SELECT mysql.STR_TO_DATE('61','%i');
SELECT mysql.STR_TO_DATE('2022-12-11 12:12:26','%h:%i:%s'); --error
SELECT STR_TO_DATE('a09:30:17','a%h:%i:%s');

--FUNCTION nesting
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 years';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 month';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2 day';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + 1;
SELECT mysql.STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s') +1;  --error
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s') +1; --error
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s') + interval '2 hour';
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s') + interval '2 minute';
SELECT mysql.STR_TO_DATE('10:12:26','%h:%i:%s') + interval '2 SECOND';
SELECT mysql.STR_TO_DATE('10:12:26','%h:%i:%s') + interval '2';
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y') + interval '2'; 
SELECT mysql.STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s') +interval '2';

drop function if exists fun0;

CREATE FUNCTION fun0(v DATE) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION fun0(v TIME) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION fun0(v datetime) RETURNS text AS $$
BEGIN
    RETURN  v::text;
END;
$$ LANGUAGE plpgsql;

select fun0(mysql.STR_TO_DATE('12:12:26','%H:%i:%s'));
select fun0(mysql.STR_TO_DATE('May 1, 2013','%M %d,%Y,%h:%i:%s'));
select fun0(mysql.str_to_date('04/30/2004', '%m/%d/%Y'));
select fun0(mysql.STR_TO_DATE('2022-12-11 14:12:26','%Y-%m-%d %H:%i:%s'));

--no_zero_date
SET lightdb_sql_mode = 'NO_ZERO_DATE'; 
SELECT str_to_date('9','%d');
SELECT STR_TO_DATE('2022-12-11 11:12:26','%Y-%m');

--prepare
prepare testfunc(varchar(100),varchar(100)) as select mysql.str_to_date($1,$2);
execute testfunc('2022-12-11 11:12:26','%Y-%m-%d');
execute testfunc('2022-12-11','%Y-%m-%d');
execute testfunc('2022-12-11 11:12:26','%Y-%m-%d %h:%i:%s');
execute testfunc('11:12:26','%h:%i:%s');


drop DATABASE if exists test_oracle;
CREATE DATABASE test_oracle with lightdb_syntax_compatible_type oracle;
\c test_oracle
set DateStyle to ISO;
set DateStyle to YMD;
show DateStyle;
CREATE EXTENSION IF NOT EXISTS myfce;
SELECT mysql.str_to_date('01,5,2013','%d,%m,%Y');
SELECT mysql.STR_TO_DATE('11:12:26','%h:%i:%s');
SELECT mysql.str_to_date('9','%m');

\c postgres
DROP DATABASE test_oracle;
DROP DATABASE test_mysql;