-- locate
\c test_mysql_myfce;
set search_path to "$user",public,lt_catalog,mysql;
select locate('1','a11111111111111',2);
select locate('1','a11111111111111',0);
select locate('1','a11111111111111',1);
select locate('1','11111111111111',1);
select locate('1','a11111111111111',-1);
SELECT locate('bar', 'foobarbar', 5);
SELECT locate('xbar', 'foobarbar', 5);

SELECT locate('bar', 'foobarbar');
SELECT locate('xbar', 'foobar');
select locate('1','a11111111111111');

-- datebase
select database();

-- test diff
SELECT DATEDIFF('2007-12-31 23:59:59','2007-12-30');
SELECT DATEDIFF('2010-11-30 23:59:59','2010-12-31');
SELECT DATEDIFF('2007-12-31 23:59:59'::timestamp,'2007-12-30 23:59:59'::timestamp);
SELECT DATEDIFF('2010-11-30'::date,'2010-12-31'::date);
SELECT DATEDIFF('2010-11-30','2010-12-31');
SELECT DATEDIFF('2010-11-30'::varchar,'2010-12-31'::varchar);
SELECT DATEDIFF(20071231,20071230);
SELECT DATEDIFF(20101130,20101231);

-- longtext
create table test_long_text(txt longtext);
insert into test_long_text values('aaaa');
\d test_long_text
select 5::longtext;
select 5::longtext || 7::longtext;
drop table test_long_text;

select year(203311); -- month is 33 ,so error. but in mysql it is NULL.
select year(201211);  -- month is 12,year is 2020
select year(20331112);
select year('20331122');
select year('20331122'::date);
select year('20331122 12:00:12'::timestamptz);
select year('20331122 12:00:12'::timestamp);
select year('20331122 12:00:12');

select day(203311); -- month is 33 ,so error. but in mysql it is NULL.
select day(201211);  -- month is 12,year is 2020
select day(20331112);
select day('20331122');
select day('20331122'::date);
select day('20331122 12:00:12'::timestamptz);
select day('20331122 12:00:12'::timestamp);
select day('20331122 12:00:12');

create table test_date (a timestamp);
insert into test_date values('2014-12-05 07:05:02');
insert into test_date values('2014-12-05 17:05:02');
select date_format(a,'%Y%y %c %h %f') from test_date;
select date_format(a,'%Y%y %c %h %f')  from test_date;
select date_format(a,'%Y%y %c %h %f')  from test_date;
select date_format(a,'%Y%y-%c %h %f')  from test_date;
select date_format(a,'%Y')  from test_date;
select date_format(a,'%Y')   from test_date;
select date_format(a,'%Y')   from test_date;
select date_format(a,'%Y %y')   from test_date;
select date_format(a,'%Y-%y%H')   from test_date;
select date_format(a,'%Y-%y%H%h')   from test_date;
select DATE_FORMAT(a,'%b %d %Y %h:%i %p')   from test_date;
select DATE_FORMAT(a,'%b %d %Y %h:%i %p')   from test_date;
select DATE_FORMAT(a,'%m-%d-%Y')   from test_date;
select DATE_FORMAT(a,'%b %d %Y %h:%i %p')   from test_date;
select DATE_FORMAT(a,'%m-%d-%Y')   from test_date;
select DATE_FORMAT(a,'%d %b %y')   from test_date;
select DATE_FORMAT(a,'%d %b %Y %T.%f')   from test_date;
select DATE_FORMAT(a,'%d %b %Y %T:%F%')   from test_date;
select DATE_FORMAT(a,'%d %b %Y %T:%f%')   from test_date;
select DATE_FORMAT(a,'%%d %b %Y %T:%f%')   from test_date;
select DATE_FORMAT(a,'%7d %b %Y %T:%f%')   from test_date;
select date_format(a,'%a,%b,%c,%D,%d,%e,%f,%H,%h,%I,%i,%j,%k,%l,%M,%m,%p,%r,%S,%s,%T,%U,%u,%V,%v,%W,%w,%X,%x,%Y,%y,%%') from test_date;
select date_format(a,'%k,%l') from test_date;
select date_format(a,'%Y-%u') from test_date;

select date_format(20140102,'%Y-%m-%d %h:%m:%s');
select date_format(20140102::text,'%Y-%m-%d %h:%m:%s');
-- In mysql is success,
select date_format(201201,'%Y-%m-%d %h:%m:%s');
-- In mysql it is NULL,when date is error.
select date_format(201401,'%Y-%m-%d %h:%m:%s');

SELECT UNCOMPRESS(COMPRESS('any string'));
-- SELECT UNCOMPRESS('any string');  -- should  null
SELECT UNCOMPRESS(COMPRESS(''));

drop table test_date;
select from_unixtime('1659067690');
select from_unixtime('1659067690'::text);
select from_unixtime(1659067690);
select from_unixtime('1659067690','%Y-%m-%d %T');
select from_unixtime('1659067690'::text,'%Y-%m-%d %T');
select from_unixtime(1659067690,'%Y-%m-%d %T');
select from_unixtime('1659067690','%Y');
select from_unixtime('1659067690'::text,'%Y');
select from_unixtime(1659067690,'%Y');

select unix_timestamp() = extract(epoch from statement_timestamp())::int8;
select unix_timestamp('20220801 14:46:10');
select unix_timestamp('20220801 14:46:10'::timestamp);
select unix_timestamp('20220801 14:46:10'::timestamptz);
select unix_timestamp('20220801'::date);
select unix_timestamp('20220801');

select ifnull('',null);
select ifnull(NULL,'is null');
select ifnull('2'::text,1);
select ifnull(2,'1'::text);

select date_sub('20220801 14:46:10',interval 1 day);
select date_sub('20220801'::date,interval 1 day);
select date_sub('20220801 14:46:10'::timestamptz,interval 1 day);
select date_sub('20220801 14:46:10'::timestamp,interval 1 day);

select date_add('20220801 14:46:10',interval 1 day);
select date_add('20220801'::date,interval 1 day);
select date_add('20220801 14:46:10'::timestamptz,interval 1 day);
select date_add('20220801 14:46:10'::timestamp,interval 1 day);

select cast('5' as  signed);

select dayofweek('20220801 14:46:10'::timestamp);
select dayofweek('20220801 14:46:10'::timestamptz);
select dayofweek('20220801 14:46:10'::date);
select dayofweek('20220801 14:46:10');
select dayofweek('20220801 14:46:10'::text);
select dayofweek(20220801);
select dayofweek('2022-08-01 14:46:10');
select dayofweek('2022-08-02 14:46:10');
select dayofweek('2022-08-03 14:46:10');
select dayofweek('2022-08-04 14:46:10');
select dayofweek('2022-08-05 14:46:10');
select dayofweek('2022-08-06 14:46:10');
select dayofweek('2022-08-07 14:46:10');

select weekofyear('20220801 14:46:10'::timestamp);
select weekofyear('20220801 14:46:10'::timestamptz);
select weekofyear('20220801 14:46:10'::date);
select weekofyear('20220801 14:46:10');
select weekofyear('20220801 14:46:10'::text);
select weekofyear(20220801);
select weekofyear('2022-01-03');

select field('Bb', 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
select field('Gg', 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
select field(123, 1.23, 12.3, 123, 1234, 0.12);
select field(123, 1.23, 12.3,  23, 1234, 0.12);

select elt(  2, 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
select elt(1.2, 'Aa', 'Bb', 'Cc', 'Dd', 'Ff');
select coalesce(elt(  0, 'Aa', 'Bb', 'Cc', 'Dd', 'Ff'), 'NULL');
select coalesce(elt( 10, 'Aa', 'Bb', 'Cc', 'Dd', 'Ff'), 'NULL');

select strcmp('text', 'text2');
select strcmp('text2', 'text');
select strcmp('text', 'text');

select log10(2);
select log10(100);
select log10(-100) is null;

select insert('Quadratic', 3, 4, 'What');
select insert('Quadratic', -1, 4, 'What');
select insert('Quadratic', 0, 2, 'What');
select insert('Quadratic', 1, 2, 'What');
select insert('Quadratic', 9, 12, 'What');
select insert('Quadratic', 3, 100, 'What');
select coalesce(insert('Quadratic', 3, 100, null), 'NULL');
select coalesce(insert('Quadratic', null, 100, 'What'), 'NULL');

select lcase('QuadRatic');

select ucase('QuadRatic');

select concat('|', space(11), '|');
select concat('|', space(-11), '|');
select concat('|', space(0), '|');

select mid('Hongye', 2, 4);
select mid('Hongye', -2, 4);
select coalesce(mid('Hongye', 12, 4), 'NULL');
select coalesce(mid('Hongye', 2, -4), 'NULL');
select coalesce(mid('Hongye', 0, 4), 'NULL');
select coalesce(mid('Hongye', 2, 0), 'NULL');

select to_days('1111-11-11');
select to_days('1111-11-11'::timestamp);
select to_days('1111-11-11'::timestamptz);
select to_days(to_date('2020-02-02', 'YYYY-MM-DD'));
select to_days('2020-02-02', 'YYYY-MM-DD');
select to_days(12340501);
select to_days(950501);
select to_days(090501);
select to_days(50501);
select to_days(1101);
select to_days(501);
select to_days(101);
select to_days(100) is null;
select to_days(51) is null;
select to_days(1) is null;
select to_days(950551) is null;
select to_days(51501) is null;

select to_seconds('2009-11-29'::timestamp);
select to_seconds('2009-11-29 13:43:32'::timestamptz) - to_seconds('1999-11-29 11:22:33'::timestamptz);

select timediff('2000-01-01 00:00:00', '2000-01-01 00:00:00.000001');
select timediff('2008-12-31 23:59:59.000001', '2008-12-30 01:01:01.000002');

select time_to_sec('22:23:00');
select time_to_sec('00:39:38');

select sec_to_time(80580);
select sec_to_time(2378);
select sec_to_time(805801);
select sec_to_time(8058011);

select to_base64('abc');
select to_base64('Hongye');

select from_base64('YWJj');
select from_base64('SG9uZ3ll');

select log2(64);
select log2(123);
select log2(0) is null;
select log2(-12) is null;

select uuid_to_bin('0768a47d-d355-372b-4926-ee668b6cb443'::uuid)::text;

select bin_to_uuid('\x0768a47dd355372b4926ee668b6cb443');

select timestampdiff ('MICROSECOND', '1911-11-11 11:23:45.123456'::timestamp, '2021-12-12 12:12:12.654321'::timestamp);
select timestampdiff ('SECOND', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('MINUTE', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('HOUR', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('DAY', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('WEEK', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('MONTH', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('QUARTER', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('YEAR', '1911-11-11 11:23:45'::timestamp, '2021-12-12 12:12:12'::timestamp);
select timestampdiff ('day', '2021-12-12 12:12:12'::timestamp, '1911-11-11 11:23:45'::timestamp);
select timestampdiff ('year','2002-01-01'::timestamp, '2001-01-01'::timestamp);
select timestampdiff ('year','2002-01-01'::timestamp, '2001-01-02'::timestamp);

select isnull(0)::text;
select isnull(1)::text;
select isnull(11)::text;
select isnull('')::text;
--select isnull('''')::text;
select isnull('x')::text;
select isnull(null)::text;
select isnull(now())::text;
select isnull('2012-12-12 12:34:56'::timestamp)::text;

select conv('123456', 10, 16);
select conv('123456', 10, 2);
select conv('1E240', 16, 10);
select conv('1E240', 16, 2);
select conv('11110001001000000', 2, 10);
select conv('11110001001000000', 2, 16);
select conv('a',16, 2);
select conv('6e',16, 10);

select rand() > 0.0;
select rand(123) > 0.0;

select if(1=1, 'yes'::bool, 'no'::bool);
select if(1=0, '1212-12-12'::timestamp, '1111-11-11'::timestamp);

select instr('abc123defnh', 'def');
select instr('abc123defnhdefabdef', 'def');
select instr('abc123defnhdefabdef', 'phm');
select instr('abc123defnhdefabdef', 'ab');
select instr('abc123defnhdefa你好aa', '你好');
select instr('abc123defnhdefa你好aa', '哈哈');
select instr('abc你好aa哈哈', '哈哈');
select instr('abc你好aa哈哈!@#$%^&*()_+-=[]{};,.', '&*');

set search_path to default;

