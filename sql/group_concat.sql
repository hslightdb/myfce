\c test_mysql_myfce;
set search_path to "$user",public,lt_catalog,mysql;

CREATE TABLE test_group_concat_tb1 (department_id INT,manager_id INT,last_name varchar(50),hiredate varchar(50),SALARY INT);
INSERT INTO test_group_concat_tb1 VALUES(30, 100, 'Raphaely', '2017-07-01', 1700);
INSERT INTO test_group_concat_tb1 VALUES(30, 100, 'De Haan', '2018-05-01',11000);
INSERT INTO test_group_concat_tb1 VALUES(40, 100, 'Errazuriz', '2017-07-21', 1400);
INSERT INTO test_group_concat_tb1 VALUES(50, 100, 'Hartstein', '2019-05-01',14000);
INSERT INTO test_group_concat_tb1 VALUES(50, 100, 'Raphaely', '2017-07-22', 1700);
INSERT INTO test_group_concat_tb1 VALUES(70, 100, 'Weiss',  '2019-07-11',13500);
INSERT INTO test_group_concat_tb1 VALUES(90, 100, 'Russell', '2019-10-05', 13000);
INSERT INTO test_group_concat_tb1 VALUES(90,100, 'Partners',  '2018-12-01',14000);
INSERT INTO test_group_concat_tb1 VALUES(90,100, 'Partners',  '2018-12-01',14000);


SELECT department_id "Dept",group_concat(  last_name   separator ':') as "Emp_list" FROM test_group_concat_tb1 group by department_id;

SELECT department_id "Dept",group_concat(  last_name   separator ',') as "Emp_list" FROM test_group_concat_tb1 group by department_id;

SELECT department_id "Dept",group_concat(  last_name  order by SALARY  separator ':') as "Emp_list" FROM test_group_concat_tb1 group by department_id;

SELECT department_id "Dept",group_concat(  distinct  last_name  order by last_name  separator ':') as "Emp_list" FROM test_group_concat_tb1  group by department_id;

SELECT department_id "Dept",group_concat(  distinct  last_name  order by last_name) as "Emp_list" FROM test_group_concat_tb1  group by department_id;

SELECT department_id "Dept",group_concat(  distinct   SALARY order by SALARY) as "Emp_list" FROM test_group_concat_tb1  group by department_id;

drop TABLE test_group_concat_tb1;

select group_concat(col1 separator ','::char) from  (values( 1.7),(1.7))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1.7),(1.7))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 1),(1))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1),(1))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '5'),('5'))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '5'),('5'))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 1.7::numeric),(1.7::numeric))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1.7::numeric),(1.7::numeric))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 1.7123::float8),(1.7123::float8))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1.7123::float8),(1.7123::float8))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 1.71234::float4),(1.71234::float4))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1.71234::float4),(1.71234::float4))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 1::bigint),(1::bigint))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 1::bigint),(1::bigint))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 2::smallint),(2::smallint))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 2::smallint),(2::smallint))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 3::int),(3::int))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 3::int),(3::int))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 'aaaa'::varchar),('aaaa'::varchar))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 'aaaa'::varchar),('aaaa'::varchar))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '1111'::varchar),('1111'::varchar))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '1111'::varchar),('1111'::varchar))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '1.1'::varchar),('1.1'::varchar))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '1.1'::varchar),('1.1'::varchar))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 'bbbba'::char),('bbbba'::char))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 'bbbba'::char),('bbbba'::char))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '111'::char),('111'::char))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '111'::char),('111'::char))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '1.1'::char),('1.1'::char))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '1.1'::char),('1.1'::char))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( 'bbbba'::char(10)),('bbbba'::char(10)))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( 'bbbba'::char(10)),('bbbba'::char(10)))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '111'::char(10)),('111'::char(10)))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '111'::char(10)),('111'::char(10)))  as t(col1);
select group_concat(col1 separator ','::char) from  (values( '1.1'::char(10)),('1.1'::char(10)))  as t(col1);
select group_concat(col1 separator ','::varchar) from  (values( '1.1'::char(10)),('1.1'::char(10)))  as t(col1);

DROP TABLE  if  EXISTS Products cascade;
CREATE TABLE Products
( id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  prod_id    char(10)      NOT NULL ,
  vend_id    char(10)      NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  varchar(1000) NULL,
  test_col int
);
--插入数据
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BR01', 'BRS01', '8 inch teddy bear', 5.99, '8 inch teddy bear, comes with cap and jacket',43);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BR02', 'BRS01', '12 inch teddy bear', 8.99, '12 inch teddy bear, comes with cap and jacket',796868);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BR03', 'BRS01', '18 inch teddy bear', 11.99, '18 inch teddy bear, comes with cap and jacket',789792);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BNBG01', 'DLL01', 'Fish bean bag toy', 3.49, 'Fish bean bag toy, complete with bean bag worms with which to feed it',2323);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BNBG02', 'DLL01', 'Bird bean bag toy', 3.49, 'Bird bean bag toy, eggs are not included',5374);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('BNBG03', 'DLL01', 'Rabbit bean bag toy', 3.49, 'Rabbit bean bag toy, comes with bean bag carrots',567922);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('RGAN01', 'DLL01', 'Raggedy Ann', 4.99, '18 inch Raggedy Ann doll',46382645);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('RYL01', 'FNG01', 'King doll', 9.49, '12 inch king doll with royal garments and crown',583942);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('RYL02', 'FNG01', 'Queen doll', 9.49,null,59723);

--默认用法
SELECT prod_price,group_concat(prod_name) from Products group by prod_price;
SELECT prod_price,group_concat(prod_name),vend_id,group_concat(prod_name) from Products group by prod_price,vend_id;

--DISTINCT
SELECT prod_name,group_concat(DISTINCT prod_price) from Products group by prod_price,prod_name;

--ORDER BY
SELECT prod_price,GROUP_CONCAT(prod_name ORDER BY prod_name) from Products GROUP BY prod_price;
SELECT prod_price,GROUP_CONCAT(prod_name ORDER BY prod_id) from Products GROUP BY prod_price;

--ASC|DESC
SELECT prod_price,GROUP_CONCAT(prod_name ORDER BY prod_name ASC) from Products GROUP BY prod_price;
SELECT prod_price,GROUP_CONCAT(prod_name ORDER BY prod_name DESC) from Products GROUP BY prod_price;


--SEPARATOR
SELECT prod_price,group_concat(prod_name SEPARATOR '~') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '!') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '@') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '#') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '$') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '%') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '^') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '&') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '*') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '(') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ')') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '-') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '_') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '=') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '+') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '[') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '{') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ']') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '}') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '|') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ';') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ':') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ',') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '<') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '.') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '>') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '/') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '?') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR ' ') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '''') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '\"') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '	') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '\\') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '\r\n') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'a') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'b') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'c') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'd') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'e') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'f') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'g') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'h') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'i') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'j') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'k') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'l') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'm') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'n') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'o') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'p') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'q') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'r') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 's') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 't') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'u') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'v') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'w') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'x') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'y') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'z') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'A') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'B') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'C') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'D') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'E') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'F') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'G') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'H') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'I') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'J') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'K') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'L') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'M') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'N') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'O') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'P') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'Q') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'R') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'S') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'T') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'U') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'V') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'W') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'X') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'Y') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR 'Z') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '0') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '1') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '2') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '3') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '4') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '5') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '6') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '7') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '8') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '9') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR '~!@#$%^&*()-_=+[{]}|;:,<.>/? 	\\ \r\n \tabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') from Products group by prod_price;
SELECT prod_price,group_concat(prod_name SEPARATOR prod_name) from Products group by prod_price;   


--AS
SELECT prod_price,group_concat(prod_name) as group_name  from Products group by prod_price;

--子查询
SELECT * from (SELECT prod_price,group_concat(prod_name) from Products group by prod_price) t;
SELECT a from (SELECT prod_price,group_concat(prod_name) as a from Products group by prod_price) t WHERE prod_price=3.49 ;

--语法组合
SELECT prod_price,GROUP_CONCAT(DISTINCT prod_name ORDER BY prod_name) from Products GROUP BY prod_price;
SELECT prod_price,group_concat(DISTINCT prod_name SEPARATOR '+') from Products group by prod_price;
SELECT prod_price,group_concat(DISTINCT prod_name) as group_name  from Products group by prod_price;
SELECT prod_price,group_concat(prod_name ORDER BY prod_name SEPARATOR '~') from Products group by prod_price;

--不写group by,
SELECT prod_name,group_concat(prod_price) from Products;
SELECT prod_name,GROUP_CONCAT(prod_desc) from Products GROUP BY prod_desc;

--俩个字段
SELECT prod_price,group_concat(prod_name,prod_price) from Products group by prod_price;

--discintct存在时,orderby后跟列序号
SELECT prod_name,group_concat(DISTINCT prod_price ORDER by 1) from Products group by prod_name;

--NULL
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price)
VALUES('43fdfd', 'fsg545', 'Rabbit bean bag toy', 4.99);
SELECT prod_name,GROUP_CONCAT(prod_desc) from Products GROUP BY prod_name;

UPDATE Products set prod_desc=null;
SELECT prod_name,GROUP_CONCAT(prod_desc) from Products GROUP BY prod_name;
UPDATE Products set prod_desc='hhah';

--超过1024
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('43fdfd', 'fsg545', '1gf incfdfdar', 4.99,'28288530274976205569733485444378750250898890809816792801028225654234323057080637771346589732609556386911111356952438563079672902408197374641646122826948017482556029162509987078483146673278772675782273803139958877958066703405297944090693216252701627564466188133702270473219328519091954576305479128225717181177365054962185631363422365305972187655282158453015807223425294222876743398985706539682738160847340952114593107555151749714080470894916987459433499288155702373653361617566353740378915981458083737041126306561017372324631925660248980059368866363110456114717993991763688266704468383009904030858729796346021728158706620695293469577511563872597011398174823163641699515191998857997053041087431385951413986083770071711540145160325187226754611308119362250433621309143895014782481319799230388115705809849111507848394580902455944120433773646773894586182486902170412974827990610451278240757352755214152054738277161588536367453734450341908234343868802746058500604470766608682800875051447870110823894463877Y
',66688);
INSERT INTO Products(prod_id, vend_id, prod_name, prod_price, prod_desc,test_col)
VALUES('43fdfd', 'fsg545', '1gf incfdfdar', 4.99,'28288530274976205569733485444378750250898890809816792801028225654234323057080637771346589732609556386911111356952438563079672902408197374641646122826948017482556029162509987078483146673278772675782273803139958877958066703405297944090693216252701627564466188133702270473219328519091954576305479128225717181177365054962185631363422365305972187655282158453015807223425294222876743398985706539682738160847340952114593107555151749714080470894916987459433499288155702373653361617566353740378915981458083737041126306561017372324631925660248980059368866363110456114717993991763688266704468383009904030858729796346021728158706620695293469577511563872597011398174823163641699515191998857997053041087431385951413986083770071711540145160325187226754611308119362250433621309143895014782481319799230388115705809849111507848394580902455944120433773646773894586182486902170412974827990610451278240757352755214152054738277161588536367453734450341908234343868802746058500604470766608682800875051447870110823894463877X
',678);
SELECT prod_name,GROUP_CONCAT(prod_desc) from Products GROUP BY prod_name;

--INTEGER类型拼接
SELECT prod_name,group_concat(test_col) from Products group by prod_name;


DROP TABLE  if  EXISTS Products cascade;

set search_path to default;
