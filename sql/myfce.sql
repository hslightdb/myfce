-- locate
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
