\c test_mysql_myfce;
set search_path to "$user",public,lt_catalog,mysql;

create table test_truncate_tb1 (sid smallint,id int,lid int8,num numeric,f4 float,f8 double precision);
insert into test_truncate_tb1 values(1,2,12,1.2,1.3,1.4);

create table test_truncate_tb2 as select truncate(sid,1) as col0, truncate(id,1) as co1,truncate(lid,1) as co2,truncate(f4,1) as co3,truncate(f8,1) as co4,truncate(num,1) as co5,truncate(1.5,2) as co6 from test_truncate_tb1;
\d test_truncate_tb2
drop table test_truncate_tb1;
drop table test_truncate_tb2;

SELECT TRUNCATE(123.4567, 3);
SELECT TRUNCATE(123.4567, 2);
SELECT TRUNCATE(123.4567, 1);
SELECT TRUNCATE(123.4567, 0);
SELECT TRUNCATE(123.4567, -1);
SELECT TRUNCATE(123.4567, -2);
SELECT TRUNCATE(123.4567, -3);
SELECT TRUNCATE(123.4567, 1.7);
SELECT TRUNCATE(123.4567, 1.3);
SELECT TRUNCATE(123.4567, 2.0);
SELECT TRUNCATE('123.4567', '2.0');
SELECT TRUNCATE(123.4567, '2.0');
SELECT TRUNCATE('123.4567', 2.0);

select TRUNCATE('1111111111111111111',2);


select truncate(1.7,'1');
select truncate(1.7,1);
select truncate(1,'1');
select truncate(1,1);
select truncate('5','1');
select truncate('5',1);
select truncate(1.7::numeric,'1');
select truncate(1.7::numeric,1);
select truncate(1.7::float8,'1');
select truncate(1.7::float8,1);
select truncate(1.7::float4,'1');
select truncate(1.7::float4,1);
select truncate(1::bigint,'1');
select truncate(1::bigint,1);
select truncate(2::smallint,'1');
select truncate(2::smallint,1);
select truncate(3::int,'1');
select truncate(3::int,1);

SELECT TRUNCATE(123.4567, 100);
SELECT TRUNCATE(0, 5);
SELECT TRUNCATE(0, -5);
SELECT TRUNCATE(0, 0);
SELECT TRUNCATE(0.0005, 2);

set search_path to default;

