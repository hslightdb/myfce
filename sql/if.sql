
select if(false,1.7,1.5);
select if(null,1.7,1.5);
create table test_if1 as select if(true,null::bigint,5) col1,if(true,null,5) col2;
select * from test_if1;
\d+ test_if1;
drop table test_if1;


select if (true, 1.7, 1.7);
select if (true, 1.7, 1);
select if (true, 1.7, '5');
select if (true, 1.7, 1.7::numeric);
select if (true, 1.7, 1.7123::float8);
select if (true, 1.7, 1.71234::float4);
select if (true, 1.7, 1::bigint);
select if (true, 1.7, 2::smallint);
select if (true, 1.7, 3::int);
select if (true, 1.7, 'aaaa'::varchar);
select if (true, 1.7, '1111'::varchar);
select if (true, 1.7, '1.1'::varchar);
select if (true, 1.7, 'bbbba'::char);
select if (true, 1.7, '111'::char);
select if (true, 1.7, '1.1'::char);
select if (true, 1.7, 'bbbba'::char(10));
select if (true, 1.7, '111'::char(10));
select if (true, 1.7, '1.1'::char(10));
select if (true, 1, 1.7);
select if (true, 1, 1);
select if (true, 1, '5');
select if (true, 1, 1.7::numeric);
select if (true, 1, 1.7123::float8);
select if (true, 1, 1.71234::float4);
select if (true, 1, 1::bigint);
select if (true, 1, 2::smallint);
select if (true, 1, 3::int);
select if (true, 1, 'aaaa'::varchar);
select if (true, 1, '1111'::varchar);
select if (true, 1, '1.1'::varchar);
select if (true, 1, 'bbbba'::char);
select if (true, 1, '111'::char);
select if (true, 1, '1.1'::char);
select if (true, 1, 'bbbba'::char(10));
select if (true, 1, '111'::char(10));
select if (true, 1, '1.1'::char(10));
select if (true, '5', 1.7);
select if (true, '5', 1);
select if (true, '5', '5');
select if (true, '5', 1.7::numeric);
select if (true, '5', 1.7123::float8);
select if (true, '5', 1.71234::float4);
select if (true, '5', 1::bigint);
select if (true, '5', 2::smallint);
select if (true, '5', 3::int);
select if (true, '5', 'aaaa'::varchar);
select if (true, '5', '1111'::varchar);
select if (true, '5', '1.1'::varchar);
select if (true, '5', 'bbbba'::char);
select if (true, '5', '111'::char);
select if (true, '5', '1.1'::char);
select if (true, '5', 'bbbba'::char(10));
select if (true, '5', '111'::char(10));
select if (true, '5', '1.1'::char(10));
select if (true, 1.7::numeric, 1.7);
select if (true, 1.7::numeric, 1);
select if (true, 1.7::numeric, '5');
select if (true, 1.7::numeric, 1.7::numeric);
select if (true, 1.7::numeric, 1.7123::float8);
select if (true, 1.7::numeric, 1.71234::float4);
select if (true, 1.7::numeric, 1::bigint);
select if (true, 1.7::numeric, 2::smallint);
select if (true, 1.7::numeric, 3::int);
select if (true, 1.7::numeric, 'aaaa'::varchar);
select if (true, 1.7::numeric, '1111'::varchar);
select if (true, 1.7::numeric, '1.1'::varchar);
select if (true, 1.7::numeric, 'bbbba'::char);
select if (true, 1.7::numeric, '111'::char);
select if (true, 1.7::numeric, '1.1'::char);
select if (true, 1.7::numeric, 'bbbba'::char(10));
select if (true, 1.7::numeric, '111'::char(10));
select if (true, 1.7::numeric, '1.1'::char(10));
select if (true, 1.7123::float8, 1.7);
select if (true, 1.7123::float8, 1);
select if (true, 1.7123::float8, '5');
select if (true, 1.7123::float8, 1.7::numeric);
select if (true, 1.7123::float8, 1.7123::float8);
select if (true, 1.7123::float8, 1.71234::float4);
select if (true, 1.7123::float8, 1::bigint);
select if (true, 1.7123::float8, 2::smallint);
select if (true, 1.7123::float8, 3::int);
select if (true, 1.7123::float8, 'aaaa'::varchar);
select if (true, 1.7123::float8, '1111'::varchar);
select if (true, 1.7123::float8, '1.1'::varchar);
select if (true, 1.7123::float8, 'bbbba'::char);
select if (true, 1.7123::float8, '111'::char);
select if (true, 1.7123::float8, '1.1'::char);
select if (true, 1.7123::float8, 'bbbba'::char(10));
select if (true, 1.7123::float8, '111'::char(10));
select if (true, 1.7123::float8, '1.1'::char(10));
select if (true, 1.71234::float4, 1.7);
select if (true, 1.71234::float4, 1);
select if (true, 1.71234::float4, '5');
select if (true, 1.71234::float4, 1.7::numeric);
select if (true, 1.71234::float4, 1.7123::float8);
select if (true, 1.71234::float4, 1.71234::float4);
select if (true, 1.71234::float4, 1::bigint);
select if (true, 1.71234::float4, 2::smallint);
select if (true, 1.71234::float4, 3::int);
select if (true, 1.71234::float4, 'aaaa'::varchar);
select if (true, 1.71234::float4, '1111'::varchar);
select if (true, 1.71234::float4, '1.1'::varchar);
select if (true, 1.71234::float4, 'bbbba'::char);
select if (true, 1.71234::float4, '111'::char);
select if (true, 1.71234::float4, '1.1'::char);
select if (true, 1.71234::float4, 'bbbba'::char(10));
select if (true, 1.71234::float4, '111'::char(10));
select if (true, 1.71234::float4, '1.1'::char(10));
select if (true, 1::bigint, 1.7);
select if (true, 1::bigint, 1);
select if (true, 1::bigint, '5');
select if (true, 1::bigint, 1.7::numeric);
select if (true, 1::bigint, 1.7123::float8);
select if (true, 1::bigint, 1.71234::float4);
select if (true, 1::bigint, 1::bigint);
select if (true, 1::bigint, 2::smallint);
select if (true, 1::bigint, 3::int);
select if (true, 1::bigint, 'aaaa'::varchar);
select if (true, 1::bigint, '1111'::varchar);
select if (true, 1::bigint, '1.1'::varchar);
select if (true, 1::bigint, 'bbbba'::char);
select if (true, 1::bigint, '111'::char);
select if (true, 1::bigint, '1.1'::char);
select if (true, 1::bigint, 'bbbba'::char(10));
select if (true, 1::bigint, '111'::char(10));
select if (true, 1::bigint, '1.1'::char(10));
select if (true, 2::smallint, 1.7);
select if (true, 2::smallint, 1);
select if (true, 2::smallint, '5');
select if (true, 2::smallint, 1.7::numeric);
select if (true, 2::smallint, 1.7123::float8);
select if (true, 2::smallint, 1.71234::float4);
select if (true, 2::smallint, 1::bigint);
select if (true, 2::smallint, 2::smallint);
select if (true, 2::smallint, 3::int);
select if (true, 2::smallint, 'aaaa'::varchar);
select if (true, 2::smallint, '1111'::varchar);
select if (true, 2::smallint, '1.1'::varchar);
select if (true, 2::smallint, 'bbbba'::char);
select if (true, 2::smallint, '111'::char);
select if (true, 2::smallint, '1.1'::char);
select if (true, 2::smallint, 'bbbba'::char(10));
select if (true, 2::smallint, '111'::char(10));
select if (true, 2::smallint, '1.1'::char(10));
select if (true, 3::int, 1.7);
select if (true, 3::int, 1);
select if (true, 3::int, '5');
select if (true, 3::int, 1.7::numeric);
select if (true, 3::int, 1.7123::float8);
select if (true, 3::int, 1.71234::float4);
select if (true, 3::int, 1::bigint);
select if (true, 3::int, 2::smallint);
select if (true, 3::int, 3::int);
select if (true, 3::int, 'aaaa'::varchar);
select if (true, 3::int, '1111'::varchar);
select if (true, 3::int, '1.1'::varchar);
select if (true, 3::int, 'bbbba'::char);
select if (true, 3::int, '111'::char);
select if (true, 3::int, '1.1'::char);
select if (true, 3::int, 'bbbba'::char(10));
select if (true, 3::int, '111'::char(10));
select if (true, 3::int, '1.1'::char(10));
select if (true, 'aaaa'::varchar, 1.7);
select if (true, 'aaaa'::varchar, 1);
select if (true, 'aaaa'::varchar, '5');
select if (true, 'aaaa'::varchar, 1.7::numeric);
select if (true, 'aaaa'::varchar, 1.7123::float8);
select if (true, 'aaaa'::varchar, 1.71234::float4);
select if (true, 'aaaa'::varchar, 1::bigint);
select if (true, 'aaaa'::varchar, 2::smallint);
select if (true, 'aaaa'::varchar, 3::int);
select if (true, 'aaaa'::varchar, 'aaaa'::varchar);
select if (true, 'aaaa'::varchar, '1111'::varchar);
select if (true, 'aaaa'::varchar, '1.1'::varchar);
select if (true, 'aaaa'::varchar, 'bbbba'::char);
select if (true, 'aaaa'::varchar, '111'::char);
select if (true, 'aaaa'::varchar, '1.1'::char);
select if (true, 'aaaa'::varchar, 'bbbba'::char(10));
select if (true, 'aaaa'::varchar, '111'::char(10));
select if (true, 'aaaa'::varchar, '1.1'::char(10));
select if (true, '1111'::varchar, 1.7);
select if (true, '1111'::varchar, 1);
select if (true, '1111'::varchar, '5');
select if (true, '1111'::varchar, 1.7::numeric);
select if (true, '1111'::varchar, 1.7123::float8);
select if (true, '1111'::varchar, 1.71234::float4);
select if (true, '1111'::varchar, 1::bigint);
select if (true, '1111'::varchar, 2::smallint);
select if (true, '1111'::varchar, 3::int);
select if (true, '1111'::varchar, 'aaaa'::varchar);
select if (true, '1111'::varchar, '1111'::varchar);
select if (true, '1111'::varchar, '1.1'::varchar);
select if (true, '1111'::varchar, 'bbbba'::char);
select if (true, '1111'::varchar, '111'::char);
select if (true, '1111'::varchar, '1.1'::char);
select if (true, '1111'::varchar, 'bbbba'::char(10));
select if (true, '1111'::varchar, '111'::char(10));
select if (true, '1111'::varchar, '1.1'::char(10));
select if (true, '1.1'::varchar, 1.7);
select if (true, '1.1'::varchar, 1);
select if (true, '1.1'::varchar, '5');
select if (true, '1.1'::varchar, 1.7::numeric);
select if (true, '1.1'::varchar, 1.7123::float8);
select if (true, '1.1'::varchar, 1.71234::float4);
select if (true, '1.1'::varchar, 1::bigint);
select if (true, '1.1'::varchar, 2::smallint);
select if (true, '1.1'::varchar, 3::int);
select if (true, '1.1'::varchar, 'aaaa'::varchar);
select if (true, '1.1'::varchar, '1111'::varchar);
select if (true, '1.1'::varchar, '1.1'::varchar);
select if (true, '1.1'::varchar, 'bbbba'::char);
select if (true, '1.1'::varchar, '111'::char);
select if (true, '1.1'::varchar, '1.1'::char);
select if (true, '1.1'::varchar, 'bbbba'::char(10));
select if (true, '1.1'::varchar, '111'::char(10));
select if (true, '1.1'::varchar, '1.1'::char(10));
select if (true, 'bbbba'::char, 1.7);
select if (true, 'bbbba'::char, 1);
select if (true, 'bbbba'::char, '5');
select if (true, 'bbbba'::char, 1.7::numeric);
select if (true, 'bbbba'::char, 1.7123::float8);
select if (true, 'bbbba'::char, 1.71234::float4);
select if (true, 'bbbba'::char, 1::bigint);
select if (true, 'bbbba'::char, 2::smallint);
select if (true, 'bbbba'::char, 3::int);
select if (true, 'bbbba'::char, 'aaaa'::varchar);
select if (true, 'bbbba'::char, '1111'::varchar);
select if (true, 'bbbba'::char, '1.1'::varchar);
select if (true, 'bbbba'::char, 'bbbba'::char);
select if (true, 'bbbba'::char, '111'::char);
select if (true, 'bbbba'::char, '1.1'::char);
select if (true, 'bbbba'::char, 'bbbba'::char(10));
select if (true, 'bbbba'::char, '111'::char(10));
select if (true, 'bbbba'::char, '1.1'::char(10));
select if (true, '111'::char, 1.7);
select if (true, '111'::char, 1);
select if (true, '111'::char, '5');
select if (true, '111'::char, 1.7::numeric);
select if (true, '111'::char, 1.7123::float8);
select if (true, '111'::char, 1.71234::float4);
select if (true, '111'::char, 1::bigint);
select if (true, '111'::char, 2::smallint);
select if (true, '111'::char, 3::int);
select if (true, '111'::char, 'aaaa'::varchar);
select if (true, '111'::char, '1111'::varchar);
select if (true, '111'::char, '1.1'::varchar);
select if (true, '111'::char, 'bbbba'::char);
select if (true, '111'::char, '111'::char);
select if (true, '111'::char, '1.1'::char);
select if (true, '111'::char, 'bbbba'::char(10));
select if (true, '111'::char, '111'::char(10));
select if (true, '111'::char, '1.1'::char(10));
select if (true, '1.1'::char, 1.7);
select if (true, '1.1'::char, 1);
select if (true, '1.1'::char, '5');
select if (true, '1.1'::char, 1.7::numeric);
select if (true, '1.1'::char, 1.7123::float8);
select if (true, '1.1'::char, 1.71234::float4);
select if (true, '1.1'::char, 1::bigint);
select if (true, '1.1'::char, 2::smallint);
select if (true, '1.1'::char, 3::int);
select if (true, '1.1'::char, 'aaaa'::varchar);
select if (true, '1.1'::char, '1111'::varchar);
select if (true, '1.1'::char, '1.1'::varchar);
select if (true, '1.1'::char, 'bbbba'::char);
select if (true, '1.1'::char, '111'::char);
select if (true, '1.1'::char, '1.1'::char);
select if (true, '1.1'::char, 'bbbba'::char(10));
select if (true, '1.1'::char, '111'::char(10));
select if (true, '1.1'::char, '1.1'::char(10));
select if (true, 'bbbba'::char(10), 1.7);
select if (true, 'bbbba'::char(10), 1);
select if (true, 'bbbba'::char(10), '5');
select if (true, 'bbbba'::char(10), 1.7::numeric);
select if (true, 'bbbba'::char(10), 1.7123::float8);
select if (true, 'bbbba'::char(10), 1.71234::float4);
select if (true, 'bbbba'::char(10), 1::bigint);
select if (true, 'bbbba'::char(10), 2::smallint);
select if (true, 'bbbba'::char(10), 3::int);
select if (true, 'bbbba'::char(10), 'aaaa'::varchar);
select if (true, 'bbbba'::char(10), '1111'::varchar);
select if (true, 'bbbba'::char(10), '1.1'::varchar);
select if (true, 'bbbba'::char(10), 'bbbba'::char);
select if (true, 'bbbba'::char(10), '111'::char);
select if (true, 'bbbba'::char(10), '1.1'::char);
select if (true, 'bbbba'::char(10), 'bbbba'::char(10));
select if (true, 'bbbba'::char(10), '111'::char(10));
select if (true, 'bbbba'::char(10), '1.1'::char(10));
select if (true, '111'::char(10), 1.7);
select if (true, '111'::char(10), 1);
select if (true, '111'::char(10), '5');
select if (true, '111'::char(10), 1.7::numeric);
select if (true, '111'::char(10), 1.7123::float8);
select if (true, '111'::char(10), 1.71234::float4);
select if (true, '111'::char(10), 1::bigint);
select if (true, '111'::char(10), 2::smallint);
select if (true, '111'::char(10), 3::int);
select if (true, '111'::char(10), 'aaaa'::varchar);
select if (true, '111'::char(10), '1111'::varchar);
select if (true, '111'::char(10), '1.1'::varchar);
select if (true, '111'::char(10), 'bbbba'::char);
select if (true, '111'::char(10), '111'::char);
select if (true, '111'::char(10), '1.1'::char);
select if (true, '111'::char(10), 'bbbba'::char(10));
select if (true, '111'::char(10), '111'::char(10));
select if (true, '111'::char(10), '1.1'::char(10));
select if (true, '1.1'::char(10), 1.7);
select if (true, '1.1'::char(10), 1);
select if (true, '1.1'::char(10), '5');
select if (true, '1.1'::char(10), 1.7::numeric);
select if (true, '1.1'::char(10), 1.7123::float8);
select if (true, '1.1'::char(10), 1.71234::float4);
select if (true, '1.1'::char(10), 1::bigint);
select if (true, '1.1'::char(10), 2::smallint);
select if (true, '1.1'::char(10), 3::int);
select if (true, '1.1'::char(10), 'aaaa'::varchar);
select if (true, '1.1'::char(10), '1111'::varchar);
select if (true, '1.1'::char(10), '1.1'::varchar);
select if (true, '1.1'::char(10), 'bbbba'::char);
select if (true, '1.1'::char(10), '111'::char);
select if (true, '1.1'::char(10), '1.1'::char);
select if (true, '1.1'::char(10), 'bbbba'::char(10));
select if (true, '1.1'::char(10), '111'::char(10));
select if (true, '1.1'::char(10), '1.1'::char(10));

select if (false, 1.7, 1.7);
select if (false, 1.7, 1);
select if (false, 1.7, '5');
select if (false, 1.7, 1.7::numeric);
select if (false, 1.7, 1.7123::float8);
select if (false, 1.7, 1.71234::float4);
select if (false, 1.7, 1::bigint);
select if (false, 1.7, 2::smallint);
select if (false, 1.7, 3::int);
select if (false, 1.7, 'aaaa'::varchar);
select if (false, 1.7, '1111'::varchar);
select if (false, 1.7, '1.1'::varchar);
select if (false, 1.7, 'bbbba'::char);
select if (false, 1.7, '111'::char);
select if (false, 1.7, '1.1'::char);
select if (false, 1.7, 'bbbba'::char(10));
select if (false, 1.7, '111'::char(10));
select if (false, 1.7, '1.1'::char(10));
select if (false, 1, 1.7);
select if (false, 1, 1);
select if (false, 1, '5');
select if (false, 1, 1.7::numeric);
select if (false, 1, 1.7123::float8);
select if (false, 1, 1.71234::float4);
select if (false, 1, 1::bigint);
select if (false, 1, 2::smallint);
select if (false, 1, 3::int);
select if (false, 1, 'aaaa'::varchar);
select if (false, 1, '1111'::varchar);
select if (false, 1, '1.1'::varchar);
select if (false, 1, 'bbbba'::char);
select if (false, 1, '111'::char);
select if (false, 1, '1.1'::char);
select if (false, 1, 'bbbba'::char(10));
select if (false, 1, '111'::char(10));
select if (false, 1, '1.1'::char(10));
select if (false, '5', 1.7);
select if (false, '5', 1);
select if (false, '5', '5');
select if (false, '5', 1.7::numeric);
select if (false, '5', 1.7123::float8);
select if (false, '5', 1.71234::float4);
select if (false, '5', 1::bigint);
select if (false, '5', 2::smallint);
select if (false, '5', 3::int);
select if (false, '5', 'aaaa'::varchar);
select if (false, '5', '1111'::varchar);
select if (false, '5', '1.1'::varchar);
select if (false, '5', 'bbbba'::char);
select if (false, '5', '111'::char);
select if (false, '5', '1.1'::char);
select if (false, '5', 'bbbba'::char(10));
select if (false, '5', '111'::char(10));
select if (false, '5', '1.1'::char(10));
select if (false, 1.7::numeric, 1.7);
select if (false, 1.7::numeric, 1);
select if (false, 1.7::numeric, '5');
select if (false, 1.7::numeric, 1.7::numeric);
select if (false, 1.7::numeric, 1.7123::float8);
select if (false, 1.7::numeric, 1.71234::float4);
select if (false, 1.7::numeric, 1::bigint);
select if (false, 1.7::numeric, 2::smallint);
select if (false, 1.7::numeric, 3::int);
select if (false, 1.7::numeric, 'aaaa'::varchar);
select if (false, 1.7::numeric, '1111'::varchar);
select if (false, 1.7::numeric, '1.1'::varchar);
select if (false, 1.7::numeric, 'bbbba'::char);
select if (false, 1.7::numeric, '111'::char);
select if (false, 1.7::numeric, '1.1'::char);
select if (false, 1.7::numeric, 'bbbba'::char(10));
select if (false, 1.7::numeric, '111'::char(10));
select if (false, 1.7::numeric, '1.1'::char(10));
select if (false, 1.7123::float8, 1.7);
select if (false, 1.7123::float8, 1);
select if (false, 1.7123::float8, '5');
select if (false, 1.7123::float8, 1.7::numeric);
select if (false, 1.7123::float8, 1.7123::float8);
select if (false, 1.7123::float8, 1.71234::float4);
select if (false, 1.7123::float8, 1::bigint);
select if (false, 1.7123::float8, 2::smallint);
select if (false, 1.7123::float8, 3::int);
select if (false, 1.7123::float8, 'aaaa'::varchar);
select if (false, 1.7123::float8, '1111'::varchar);
select if (false, 1.7123::float8, '1.1'::varchar);
select if (false, 1.7123::float8, 'bbbba'::char);
select if (false, 1.7123::float8, '111'::char);
select if (false, 1.7123::float8, '1.1'::char);
select if (false, 1.7123::float8, 'bbbba'::char(10));
select if (false, 1.7123::float8, '111'::char(10));
select if (false, 1.7123::float8, '1.1'::char(10));
select if (false, 1.71234::float4, 1.7);
select if (false, 1.71234::float4, 1);
select if (false, 1.71234::float4, '5');
select if (false, 1.71234::float4, 1.7::numeric);
select if (false, 1.71234::float4, 1.7123::float8);
select if (false, 1.71234::float4, 1.71234::float4);
select if (false, 1.71234::float4, 1::bigint);
select if (false, 1.71234::float4, 2::smallint);
select if (false, 1.71234::float4, 3::int);
select if (false, 1.71234::float4, 'aaaa'::varchar);
select if (false, 1.71234::float4, '1111'::varchar);
select if (false, 1.71234::float4, '1.1'::varchar);
select if (false, 1.71234::float4, 'bbbba'::char);
select if (false, 1.71234::float4, '111'::char);
select if (false, 1.71234::float4, '1.1'::char);
select if (false, 1.71234::float4, 'bbbba'::char(10));
select if (false, 1.71234::float4, '111'::char(10));
select if (false, 1.71234::float4, '1.1'::char(10));
select if (false, 1::bigint, 1.7);
select if (false, 1::bigint, 1);
select if (false, 1::bigint, '5');
select if (false, 1::bigint, 1.7::numeric);
select if (false, 1::bigint, 1.7123::float8);
select if (false, 1::bigint, 1.71234::float4);
select if (false, 1::bigint, 1::bigint);
select if (false, 1::bigint, 2::smallint);
select if (false, 1::bigint, 3::int);
select if (false, 1::bigint, 'aaaa'::varchar);
select if (false, 1::bigint, '1111'::varchar);
select if (false, 1::bigint, '1.1'::varchar);
select if (false, 1::bigint, 'bbbba'::char);
select if (false, 1::bigint, '111'::char);
select if (false, 1::bigint, '1.1'::char);
select if (false, 1::bigint, 'bbbba'::char(10));
select if (false, 1::bigint, '111'::char(10));
select if (false, 1::bigint, '1.1'::char(10));
select if (false, 2::smallint, 1.7);
select if (false, 2::smallint, 1);
select if (false, 2::smallint, '5');
select if (false, 2::smallint, 1.7::numeric);
select if (false, 2::smallint, 1.7123::float8);
select if (false, 2::smallint, 1.71234::float4);
select if (false, 2::smallint, 1::bigint);
select if (false, 2::smallint, 2::smallint);
select if (false, 2::smallint, 3::int);
select if (false, 2::smallint, 'aaaa'::varchar);
select if (false, 2::smallint, '1111'::varchar);
select if (false, 2::smallint, '1.1'::varchar);
select if (false, 2::smallint, 'bbbba'::char);
select if (false, 2::smallint, '111'::char);
select if (false, 2::smallint, '1.1'::char);
select if (false, 2::smallint, 'bbbba'::char(10));
select if (false, 2::smallint, '111'::char(10));
select if (false, 2::smallint, '1.1'::char(10));
select if (false, 3::int, 1.7);
select if (false, 3::int, 1);
select if (false, 3::int, '5');
select if (false, 3::int, 1.7::numeric);
select if (false, 3::int, 1.7123::float8);
select if (false, 3::int, 1.71234::float4);
select if (false, 3::int, 1::bigint);
select if (false, 3::int, 2::smallint);
select if (false, 3::int, 3::int);
select if (false, 3::int, 'aaaa'::varchar);
select if (false, 3::int, '1111'::varchar);
select if (false, 3::int, '1.1'::varchar);
select if (false, 3::int, 'bbbba'::char);
select if (false, 3::int, '111'::char);
select if (false, 3::int, '1.1'::char);
select if (false, 3::int, 'bbbba'::char(10));
select if (false, 3::int, '111'::char(10));
select if (false, 3::int, '1.1'::char(10));
select if (false, 'aaaa'::varchar, 1.7);
select if (false, 'aaaa'::varchar, 1);
select if (false, 'aaaa'::varchar, '5');
select if (false, 'aaaa'::varchar, 1.7::numeric);
select if (false, 'aaaa'::varchar, 1.7123::float8);
select if (false, 'aaaa'::varchar, 1.71234::float4);
select if (false, 'aaaa'::varchar, 1::bigint);
select if (false, 'aaaa'::varchar, 2::smallint);
select if (false, 'aaaa'::varchar, 3::int);
select if (false, 'aaaa'::varchar, 'aaaa'::varchar);
select if (false, 'aaaa'::varchar, '1111'::varchar);
select if (false, 'aaaa'::varchar, '1.1'::varchar);
select if (false, 'aaaa'::varchar, 'bbbba'::char);
select if (false, 'aaaa'::varchar, '111'::char);
select if (false, 'aaaa'::varchar, '1.1'::char);
select if (false, 'aaaa'::varchar, 'bbbba'::char(10));
select if (false, 'aaaa'::varchar, '111'::char(10));
select if (false, 'aaaa'::varchar, '1.1'::char(10));
select if (false, '1111'::varchar, 1.7);
select if (false, '1111'::varchar, 1);
select if (false, '1111'::varchar, '5');
select if (false, '1111'::varchar, 1.7::numeric);
select if (false, '1111'::varchar, 1.7123::float8);
select if (false, '1111'::varchar, 1.71234::float4);
select if (false, '1111'::varchar, 1::bigint);
select if (false, '1111'::varchar, 2::smallint);
select if (false, '1111'::varchar, 3::int);
select if (false, '1111'::varchar, 'aaaa'::varchar);
select if (false, '1111'::varchar, '1111'::varchar);
select if (false, '1111'::varchar, '1.1'::varchar);
select if (false, '1111'::varchar, 'bbbba'::char);
select if (false, '1111'::varchar, '111'::char);
select if (false, '1111'::varchar, '1.1'::char);
select if (false, '1111'::varchar, 'bbbba'::char(10));
select if (false, '1111'::varchar, '111'::char(10));
select if (false, '1111'::varchar, '1.1'::char(10));
select if (false, '1.1'::varchar, 1.7);
select if (false, '1.1'::varchar, 1);
select if (false, '1.1'::varchar, '5');
select if (false, '1.1'::varchar, 1.7::numeric);
select if (false, '1.1'::varchar, 1.7123::float8);
select if (false, '1.1'::varchar, 1.71234::float4);
select if (false, '1.1'::varchar, 1::bigint);
select if (false, '1.1'::varchar, 2::smallint);
select if (false, '1.1'::varchar, 3::int);
select if (false, '1.1'::varchar, 'aaaa'::varchar);
select if (false, '1.1'::varchar, '1111'::varchar);
select if (false, '1.1'::varchar, '1.1'::varchar);
select if (false, '1.1'::varchar, 'bbbba'::char);
select if (false, '1.1'::varchar, '111'::char);
select if (false, '1.1'::varchar, '1.1'::char);
select if (false, '1.1'::varchar, 'bbbba'::char(10));
select if (false, '1.1'::varchar, '111'::char(10));
select if (false, '1.1'::varchar, '1.1'::char(10));
select if (false, 'bbbba'::char, 1.7);
select if (false, 'bbbba'::char, 1);
select if (false, 'bbbba'::char, '5');
select if (false, 'bbbba'::char, 1.7::numeric);
select if (false, 'bbbba'::char, 1.7123::float8);
select if (false, 'bbbba'::char, 1.71234::float4);
select if (false, 'bbbba'::char, 1::bigint);
select if (false, 'bbbba'::char, 2::smallint);
select if (false, 'bbbba'::char, 3::int);
select if (false, 'bbbba'::char, 'aaaa'::varchar);
select if (false, 'bbbba'::char, '1111'::varchar);
select if (false, 'bbbba'::char, '1.1'::varchar);
select if (false, 'bbbba'::char, 'bbbba'::char);
select if (false, 'bbbba'::char, '111'::char);
select if (false, 'bbbba'::char, '1.1'::char);
select if (false, 'bbbba'::char, 'bbbba'::char(10));
select if (false, 'bbbba'::char, '111'::char(10));
select if (false, 'bbbba'::char, '1.1'::char(10));
select if (false, '111'::char, 1.7);
select if (false, '111'::char, 1);
select if (false, '111'::char, '5');
select if (false, '111'::char, 1.7::numeric);
select if (false, '111'::char, 1.7123::float8);
select if (false, '111'::char, 1.71234::float4);
select if (false, '111'::char, 1::bigint);
select if (false, '111'::char, 2::smallint);
select if (false, '111'::char, 3::int);
select if (false, '111'::char, 'aaaa'::varchar);
select if (false, '111'::char, '1111'::varchar);
select if (false, '111'::char, '1.1'::varchar);
select if (false, '111'::char, 'bbbba'::char);
select if (false, '111'::char, '111'::char);
select if (false, '111'::char, '1.1'::char);
select if (false, '111'::char, 'bbbba'::char(10));
select if (false, '111'::char, '111'::char(10));
select if (false, '111'::char, '1.1'::char(10));
select if (false, '1.1'::char, 1.7);
select if (false, '1.1'::char, 1);
select if (false, '1.1'::char, '5');
select if (false, '1.1'::char, 1.7::numeric);
select if (false, '1.1'::char, 1.7123::float8);
select if (false, '1.1'::char, 1.71234::float4);
select if (false, '1.1'::char, 1::bigint);
select if (false, '1.1'::char, 2::smallint);
select if (false, '1.1'::char, 3::int);
select if (false, '1.1'::char, 'aaaa'::varchar);
select if (false, '1.1'::char, '1111'::varchar);
select if (false, '1.1'::char, '1.1'::varchar);
select if (false, '1.1'::char, 'bbbba'::char);
select if (false, '1.1'::char, '111'::char);
select if (false, '1.1'::char, '1.1'::char);
select if (false, '1.1'::char, 'bbbba'::char(10));
select if (false, '1.1'::char, '111'::char(10));
select if (false, '1.1'::char, '1.1'::char(10));
select if (false, 'bbbba'::char(10), 1.7);
select if (false, 'bbbba'::char(10), 1);
select if (false, 'bbbba'::char(10), '5');
select if (false, 'bbbba'::char(10), 1.7::numeric);
select if (false, 'bbbba'::char(10), 1.7123::float8);
select if (false, 'bbbba'::char(10), 1.71234::float4);
select if (false, 'bbbba'::char(10), 1::bigint);
select if (false, 'bbbba'::char(10), 2::smallint);
select if (false, 'bbbba'::char(10), 3::int);
select if (false, 'bbbba'::char(10), 'aaaa'::varchar);
select if (false, 'bbbba'::char(10), '1111'::varchar);
select if (false, 'bbbba'::char(10), '1.1'::varchar);
select if (false, 'bbbba'::char(10), 'bbbba'::char);
select if (false, 'bbbba'::char(10), '111'::char);
select if (false, 'bbbba'::char(10), '1.1'::char);
select if (false, 'bbbba'::char(10), 'bbbba'::char(10));
select if (false, 'bbbba'::char(10), '111'::char(10));
select if (false, 'bbbba'::char(10), '1.1'::char(10));
select if (false, '111'::char(10), 1.7);
select if (false, '111'::char(10), 1);
select if (false, '111'::char(10), '5');
select if (false, '111'::char(10), 1.7::numeric);
select if (false, '111'::char(10), 1.7123::float8);
select if (false, '111'::char(10), 1.71234::float4);
select if (false, '111'::char(10), 1::bigint);
select if (false, '111'::char(10), 2::smallint);
select if (false, '111'::char(10), 3::int);
select if (false, '111'::char(10), 'aaaa'::varchar);
select if (false, '111'::char(10), '1111'::varchar);
select if (false, '111'::char(10), '1.1'::varchar);
select if (false, '111'::char(10), 'bbbba'::char);
select if (false, '111'::char(10), '111'::char);
select if (false, '111'::char(10), '1.1'::char);
select if (false, '111'::char(10), 'bbbba'::char(10));
select if (false, '111'::char(10), '111'::char(10));
select if (false, '111'::char(10), '1.1'::char(10));
select if (false, '1.1'::char(10), 1.7);
select if (false, '1.1'::char(10), 1);
select if (false, '1.1'::char(10), '5');
select if (false, '1.1'::char(10), 1.7::numeric);
select if (false, '1.1'::char(10), 1.7123::float8);
select if (false, '1.1'::char(10), 1.71234::float4);
select if (false, '1.1'::char(10), 1::bigint);
select if (false, '1.1'::char(10), 2::smallint);
select if (false, '1.1'::char(10), 3::int);
select if (false, '1.1'::char(10), 'aaaa'::varchar);
select if (false, '1.1'::char(10), '1111'::varchar);
select if (false, '1.1'::char(10), '1.1'::varchar);
select if (false, '1.1'::char(10), 'bbbba'::char);
select if (false, '1.1'::char(10), '111'::char);
select if (false, '1.1'::char(10), '1.1'::char);
select if (false, '1.1'::char(10), 'bbbba'::char(10));
select if (false, '1.1'::char(10), '111'::char(10));
select if (false, '1.1'::char(10), '1.1'::char(10));

drop table if exists test_if cascade;

CREATE TABLE test_if(c1 smallint NOT NULL,
					 c2 INTEGER NOT NULL,
					 c3 BIGINT NOT NULL,
					 c4 numeric NOT NULL,
					 c5 double precision NOT NULL,
					 c6 decimal NOT NULL,
					 c7 REAL NOT NULL,
					 c8 NUMBER not NULL,
					 c9 text not NULL,
					 c10 char not null,
					 c11 CHAR(10) not null,
					 c12 VARCHAR NOT NULL				 
);

INSERT INTO test_if VALUES(234,4354,4354,789.432,8.9,67.90,322.89,323.456,'GUFGD','h','ugwugd','你好');


drop table if exists ts1 cascade;

create table ts1 AS select if(true,c1,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c1,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c1,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c2,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c2,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c3,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c3,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c4,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c4,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c5,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c5,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c6,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c6,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c7,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c7,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c8,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c8,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c9,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c9,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c10,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c10,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c11,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c11,c12) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c1) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c1) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c2) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c2) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c3) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c3) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c4) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c4) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c5) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c5) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c6) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c6) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c7) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c7) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c8) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c8) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c9) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c9) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c10) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c10) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c11) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c11) as co1 from test_if;
\d ts1;

drop table ts1;

create table ts1 AS select if(true,c12,c12) as co1 from test_if;
\d ts1;

drop table ts1;
create table ts1 AS select if(false,c12,c12) as co1 from test_if;
\d ts1;

drop table ts1;
drop table test_if;
select if(1,1,3);  
select if(0,1,3);  
SELECT IF(find_in_set('a','a,b,c'),'no','yes'); 
select if(32767::smallint,3.3::decimal); 
