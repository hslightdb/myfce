----------------------------------
-------test find_in_set-----------
----------------------------------
\c test_mysql_myfce;
set lc_monetary = "C";
set search_path to "$user",public,lt_catalog,mysql;

select find_in_set('a', 'a,b,c,d');
select find_in_set(' a', 'a,b,c,d');
select find_in_set('a', ' a,b,c,d');
select find_in_set(' a', ' a,b,c,d');
select find_in_set('b', 'a ,b,c,d');
select find_in_set('b', 'a ,b ,c,d');

select find_in_set(1,'1,2,3');
select find_in_set(1.1,'1.1,2,3');


select find_in_set(null,'1,2,3');
select find_in_set(1,null);


select find_in_set('1111111111111111111','1111111111111111111,2');

select find_in_set('','A,,,,,');
select find_in_set(1.7::numeric,'1,aaa,1.7,2,3,,');
select find_in_set(1.7::numeric,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(1.7::float8,'1,aaa,1.7,2,3,,');
select find_in_set(1.7::float8,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(1.7::float4,'1,aaa,1.7,2,3,,');
select find_in_set(1.7::float4,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(1::bigint,'1,aaa,1.7,2,3,,');
select find_in_set(1::bigint,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(2::smallint,'1,aaa,1.7,2,3,,');
select find_in_set(2::smallint,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(3::int,'1,aaa,1.7,2,3,,');
select find_in_set(3::int,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set(1.7,'1,aaa,1.7,2,3,,');
select find_in_set(1.7,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('aaa','1,aaa,1.7,2,3,,');
select find_in_set('aaa','1,aaa,2,1.7,3,,'::varchar);
select find_in_set(1,'1,aaa,1.7,2,3,,');
select find_in_set(1,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('5','1,aaa,1.7,2,3,,');
select find_in_set('5','1,aaa,2,1.7,3,,'::varchar);
select find_in_set('aaaa'::varchar,'1,aaa,1.7,2,3,,');
select find_in_set('aaaa'::varchar,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('1111'::varchar,'1,aaa,1.7,2,3,,');
select find_in_set('1111'::varchar,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('1.1'::varchar,'1,aaa,1.7,2,3,,');
select find_in_set('1.1'::varchar,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('bbbba'::char,'1,aaa,1.7,2,3,,');
select find_in_set('bbbba'::char,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('111'::char,'1,aaa,1.7,2,3,,');
select find_in_set('111'::char,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('1.1'::char,'1,aaa,1.7,2,3,,');
select find_in_set('1.1'::char,'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('bbbba'::char(10),'1,aaa,1.7,2,3,,');
select find_in_set('bbbba'::char(10),'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('111'::char(10),'1,aaa,1.7,2,3,,');
select find_in_set('111'::char(10),'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('1.1'::char(10),'1,aaa,1.7,2,3,,');
select find_in_set('1.1'::char(10),'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('aaa'::char(10),'1,aaa,2,1.7,3,,'::varchar);
select find_in_set('aaa'::char(10),'1,aaa,2,1.7,3,,'::text);
select find_in_set('aaa'::char(10),'1,aaa,2,1.7,3,,');
select find_in_set(' aaa'::char(10),'1, aaa,2,1.7,3,,');

----------------------------------
------------test CASE-------------
----------------------------------

--新增表
create table teacher1 (sno bigint,tid smallint, name varchar(20),student char(20),grade FLOAT,leve DOUBLE precision,study text);

--插入
INSERT INTO teacher1 VALUES ('110','1','abc','Lily',0.0111,11.10,'abcd');
INSERT INTO teacher1 VALUES ('111','2','a','zhangsan',0.012,13.10,'abcd');
INSERT INTO teacher1 VALUES ('112','3','ab','wangwu',0.021,10.10,'a');
INSERT INTO teacher1 VALUES ('113','4','abc','lisi',0.021,13.12,'abc');
INSERT INTO teacher1 VALUES ('114','5','a','Anna',0.01,10.22,'a');
INSERT INTO teacher1 VALUES ('115','6','abc','Lay',0.010,10.22,'ab');

--暂不支持where子句
SELECT * FROM teacher1 WHERE find_in_set('a', 'a,b,c,d'); --为真
SELECT * FROM teacher1 WHERE find_in_set('e', 'a,b,c,d'); --为假

--INSERT
INSERT INTO teacher1 VALUES (find_in_set('a', 'a,b,c,d'),'6','abc','Lay',0.010,10.22);
INSERT INTO teacher1 VALUES (find_in_set(null, 'a,b,c,d'),'6','abc','Lay',0.010,10.22);

--UPDATE
UPDATE teacher1 SET sno = find_in_set('a', 'a,b,c,d') WHERE tid = 2;
UPDATE teacher1 SET grade = find_in_set('a', 'a,b,c,d') WHERE tid = 2;

--作操作符
select find_in_set(sno,'10,2,4131')  from teacher1;
select find_in_set(tid,'1,12,4131')  from teacher1;
select find_in_set(student,'Lily,joe,leo,hs')  from teacher1;
select find_in_set(name,'Lily,joe,leo,hs')  from teacher1;
select find_in_set(grade,'1,1.01,0.01,4131')  from teacher1;
select find_in_set(leve,'1,1.01,0.01,10.22')  from teacher1;
select find_in_set(study, 'a,b,c,d') FROM teacher1;

drop table teacher1;

--SELECT text
select find_in_set('a', 'a,b,c,d');
select find_in_set('a'::CHAR, 'a,b,c,d');
select find_in_set('a'::VARCHAR, 'a,b,c,d');
select find_in_set('a'::text, 'a,b,c,d');
select find_in_set('a  ', 'a  ,b,c,d');

--含逗号或引号
select find_in_set('c', 'a,b,,,,c,d'); --返回6
select find_in_set('a,b,c', 'a,b,c,d'); --返回0
select find_in_set('a,b,c', "'a,b,c',d"); --mysql返回0，pg报语法错误

--包含null或空
select find_in_set(null, 'a,b,c,d');
select find_in_set(null, null);
select find_in_set('a', null);
select find_in_set('', 'a  ,b,c,d');
select find_in_set('abc', '');

--超长字符串列表
select find_in_set('a', 'ab,b,c,d,abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz,a');
--超长字符串
select find_in_set('abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz', 'ab,b,c,d,abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz,a');

SELECT find_in_set('12','123,12,1234,12345,1234567890123456789012345678901234567890123456789012345678901234 1');

--bigint
SELECT find_in_set('12'::bigint,'123,12,1234,12345,12');
--FLOAT4
SELECT find_in_set('12.0'::FLOAT4,'123,12,1234');
--FLOAT8
SELECT find_in_set('12.0'::FLOAT8,'123,12,1234');
--double precision
SELECT find_in_set('12.0'::double precision,'123,12,1234');
--smallint
SELECT find_in_set('12'::smallint,'123,12,1234');
--int4
SELECT find_in_set('12'::int4,'123,12,1234');
--FLOAT
SELECT find_in_set('12.0','123,12,1234,12345,12');
SELECT find_in_set('12.0000000001','123,12,1234,12345,12.0000000001');
SELECT find_in_set('0.0000000001','123,12,0.0001,12345,0.0000000001');

--其他基础类型
--json
SELECT find_in_set('{"isQueuing":false}'::json,'01,{"isQueuing":false}'); --返回2
SELECT find_in_set('{"isQueuing":false}'::json,'01{"isQueuing":false}'); --返回0
SELECT find_in_set('{"isQueuing":false}'::json,'{"isQueuing": false}'); --带空格返回0
--BOOLEAN
SELECT find_in_set(FALSE::boolean,'123,FALSE,1234');
SELECT find_in_set(FALSE::boolean,'123,f,1234');
SELECT find_in_set('FALSE'::boolean,'123,false,1234');
SELECT find_in_set('false'::boolean,'123,false,1234');
SELECT find_in_set('false'::boolean,'123,f,1234');
SELECT find_in_set('false'::boolean,'123,F,1234');
--DATE
SELECT find_in_set('2021-01-23'::date,'123,20210123,1234');
SELECT find_in_set('20210123'::date,'123,2021-01-23,1234');
SELECT find_in_set('2021-01-23'::date,'123,2021-01-23,1234');
SELECT find_in_set('20:21:01'::time,'123,202101,1234');
SELECT find_in_set('20:21:01'::time,'123,20:21:01,1234');
SELECT find_in_set('10000'::interval,'123,10,1234');
SELECT find_in_set('10000'::interval,'123,10000,1234');
SELECT find_in_set('10000'::interval,'123,02:46:40,1234');
SELECT find_in_set('2021-01-23 10:10:10'::timestamp ,'123,2021-01-23 10:10:10,1234');
--money
SELECT find_in_set('6544.11'::money,'123,6544.11,1234');
SELECT find_in_set('6544.11'::money,'123,$6544.11,1234');
SELECT find_in_set('654.11'::money,'123,$654.11,1234');
--bytea
SELECT find_in_set('654.11'::bytea,'123,654.11,1234');
SELECT find_in_set('654.11'::bytea,'123,\x3635342e3131,1234');
--inet
SELECT find_in_set('10.20.30.155'::inet,'123,10.20.30.155,1234');
SELECT find_in_set('10.20.30.155'::inet,'123,10.20.30.155/25,1234');


--存在多个匹配,返回第一个匹配到的下标
SELECT find_in_set('a', 'a,a,a,b,c,d');
SELECT find_in_set('12','123,12,1234,12345,12');
SELECT find_in_set('12_a','123,12_a,1234,12345');
SELECT find_in_set('12','123,12,1234,12345');

--特殊字符
--增加支持汉字，乱码
select find_in_set('恒生', 'a,恒生,c,d');
select find_in_set('恒生', 'a,恒生2,c,d');
select find_in_set('~','a,b,cd,~');
select find_in_set('!','a,b,cd,!');
select find_in_set('@','a,b,cd,@');
select find_in_set('#','a,b,cd,#');
select find_in_set('$','a,b,cd,$');
select find_in_set('%','a,b,cd,%');
select find_in_set('^','a,b,cd,^');
select find_in_set('&','a,b,cd,&');
select find_in_set('*','a,b,cd,*');
select find_in_set('(','a,b,cd,(');
select find_in_set(');','a,b,cd,);');
select find_in_set('-','a,b,cd,-');
select find_in_set('_','a,b,cd,_');
select find_in_set('=','a,b,cd,=');
select find_in_set('+','a,b,cd,+');
select find_in_set('[','a,b,cd,[');
select find_in_set('{','a,b,cd,{');
select find_in_set(']','a,b,cd,]');
select find_in_set('}','a,b,cd,}');
select find_in_set('|','a,b,cd,|');
select find_in_set(';','a,b,cd,;');
select find_in_set(':','a,b,cd,:');
select find_in_set(',','a,b,cd,,');
select find_in_set('<','a,b,cd,<');
select find_in_set('.','a,b,cd,.');
select find_in_set('>','a,b,cd,>');
select find_in_set('/','a,b,cd,/');
select find_in_set('?','a,b,cd,?');
select find_in_set(' ','a,b,cd, ');
select find_in_set('	','a,b,cd,	');
select find_in_set('''','a,b,cd,''');
select find_in_set('"\"','a,b,cd,"\"');

select find_in_set('"','a,b,cd,"');
select find_in_set('"','a,b,cd,@#');


--大小写字符敏感（mysql是大小写不敏感）
select find_in_set('A','a,b,cd,a');
select find_in_set('B','a,b,cd,a');
select find_in_set('C','a,b,cd,b');
select find_in_set('cD','a,b,cd,c');

select find_in_set('d','a,b,cd,D');
select find_in_set('e','a,b,cd,E');
select find_in_set('cd','a,b,CD,f');

select find_in_set('0a','a,b,cd,0A');
select find_in_set('1A','a,b,cd,1a');

set search_path to default;
