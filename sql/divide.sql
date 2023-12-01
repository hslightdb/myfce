-- test mysql divide compatible
\c test_mysql_myfce;
show search_path;

-- use explicit mysql schema
select 2 operator(mysql./) 4;
select 4 operator(mysql./) 4;
select 1 operator(mysql./) 3;
select 2.0 operator(mysql./) 4;
select 2 operator(mysql./) 4.0;
select '2' operator(mysql./) 4;
select '22' operator(mysql./) 4;
select '22' operator(mysql./) '3';

-- test normal case
select 2 / 4;
select 1 / 4;
select 2 / 2;
select 10 / 3;
select 2*20 / 2;
select 2^10 / 3;    -- mysql not support ^, pg support
select 5! / 2;      -- mysql not support !, pg support
select abs(-9) / 2;
select power(2,32) / 2;
select power(2,32) + 1 / 2;
select (power(2,32) + 1) / 2;
select (power(2,64) + 1) / 2;
select -1 / -2;
select -2 / -3;
select -2 / 4;
select 2 / -3;
select abs(-9) / -2;
select 2::int2 / 4::int2;
select 2::int2 / 4::int4;
select 2::int2 / 4::int8;
select 2::int4 / 4::int2;
select 2::int4 / 4::int4;
select 2::int4 / 4::int8;
select 2::int8 / 4::int2;
select 2::int8 / 4::int4;
select 2::int8 / 4::int8;

-- test range
select 10000000000::int2 / 2;
select 2 / 10000000000::int2;
select (2^16)::int2 / 2;
select (2^15 -1)::int2 / 2;
select (-1 * 2^15)::int2 / 2;
select (-1 * 2^15 - 1)::int2 / 2;
select (2^31 - 1)::int4 / 2;
select (2^31)::int4 / 4;
select (-1 * 2^31)::int4 / 2;
select (-1 * 2^31 - 1)::int4 / 2;
select 9223372036854775807::int8 / 2;           -- int8 range (-9223372036854775808, +9223372036854775807]
select (9223372036854775807 + 1)::int8 / 2;
select (-1 * 2^63)::int8 / 2;
select (-1 * 2^63 -1)::int8 / 2;
select -9223372036854775808::int8 / 2;
select (-9223372036854775808 + 1)::int8 / 2;
select 2 / (2^16)::int2;
select 2 / (2^31)::int4;
select 2 / (9223372036854775807 + 1);


-- test float
select 2.0 / 4;
select 2.0 / 4.0;
select 2 / 4.0;
select 1.0 / 3;

-- test char digit
select '2' / 4;
select 2 / '4';
select '2' / '4';
select '2.2' / '4.2';
select '2.0' / 2;
select 22 / '2.2';

-- test div null
select 2 / null;
select null / 2;
select null / null;
select 2.0 / null;
select null / 2.0;
select '2' / null;
select '2.2' / null;
select null / '2.2';
select null / '2';

-- search path
set search_path to public;
show search_path;
select 10 / 2;
select 8 / 15;
select 1000 / 2000;

set search_path to mysql;
select 3 / 5;
select 8 / 3;
select 2 / 4;

set search_path to default;

-- test table
create table test_divide(a int, b int, c decimal);
insert into test_divide values(1, 1, 2 / 4);
insert into test_divide values(2, 4, 3 / 2);
select * from test_divide;
select a, b, a / b from test_divide;


set search_path to default;