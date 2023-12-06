---test gbk order by---

create database test_to_char with lightdb_syntax_compatible_type 'oracle';

\c test_to_char
CREATE extension "uuid-ossp";
CREATE schema lt_catalog;
CREATE extension orafce;

CREATE TABLE test_tochar  (id int,v VARCHAR(10),c CHAR(10),v2 VARCHAR2(10),t text,clb CLOB);

INSERT INTO test_tochar VALUES(11,'测试中文','测试中文','测试中文','测试中文,text本类型','测试中文' );
INSERT INTO test_tochar VALUES(11,'English','English','English','English','English' );
INSERT INTO test_tochar VALUES(12,'1012','2022','32022','42022','52022' );

----SELECT
SELECT * from test_tochar;
SELECT to_char(id) from test_tochar ;
SELECT to_char(v) from test_tochar ;
SELECT to_char(c) from test_tochar ;
SELECT to_char(v2) from test_tochar ;
SELECT to_char(t) from test_tochar ;
SELECT to_char(clb) from test_tochar ;

---unkonw
SELECT to_char('test');
SELECT to_char('12345');
SELECT to_char('中文');
SELECT oracle.to_char('test');
SELECT oracle.to_char('12345');
SELECT oracle.to_char('中文');


--insert into
insert into test_tochar values(to_char('12'),to_char('中文'),to_char('中文'),to_char('中文'),to_char('中文'),to_char('中文'));

---ltrim
select ltrim(TO_CHAR('testabc123'),'test'); 

select btrim(TO_CHAR('testabc123'),'test'); 

drop TABLE test_tochar;
\c postgres
drop database test_to_char;
