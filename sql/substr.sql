DROP DATABASE IF EXISTS lttest_mysql_mode_for_substr;
CREATE DATABASE lttest_mysql_mode_for_substr WITH lightdb_syntax_compatible_type 'mysql';

\c lttest_mysql_mode_for_substr;
\pset null NULL;

CREATE EXTENSION IF NOT EXISTS myfce;


-- substr check begin

-- illegal input param
select substr();
select substr('');
select substr('',);
select substr('','');
select substr('abc');
select substr('abc','@');

-- null CHECK

select substr(NULL,NULL,NULL);
select substr(NULL,NULL,0);
select substr(NULL,0,0);

-- empty string check
select substr('',0);
select substr('',1);
select substr('',0,0);
select substr('',1,0);

-- pos 0 CHECK
select substr('abc',0);
select substr('abc',0,1);

-- len < 1 CHECK

select substr('abc',1,0.4);
select substr('abc',1,0.5);
select substr('abc',1,0);
select substr('abc',1,-1);

-- POS <0 CHECK
select substr('abc',-1,1);
select substr('abc',-0.5,1);
select substr('abc',-0.4,1);

-- pos excced limit check

select substr('abc',4,3);
select substr('abc',-4,3);


-- pos round CHECK
select substr('abc',0.5,1);
select substr('abc',-0.5,1);
select substr('abc',0.4,1);
select substr('abc',-0.4,1);

-- len round CHECK
select substr('abc',1,0.5);
select substr('abc',1,0.4);

--both pos&len round CHECK
select substr('abc',0.5,0.5);
select substr('abc' ,0.5,0.4);
select substr('abc' ,0.4,0.5);
select substr('abc',0.4,0.4);

-- check wchar
select substr('汉字abc',1);
select substr('汉字abc',1,1);
select substr('汉字abc',-2,2);


--substr check end

-- substring check begin

-- illegal input param
select substring();
select substring('');
select substring('',);
select substring('','')
select substring('abc');
select substring('abc','@');

-- null CHECK

select substring(NULL,NULL,NULL);
select substring(NULL,NULL,0);
select substring(NULL,0,0);

-- empty string check
--select substring('',0);
--select substring('',1);
--select substring('',0,0);
--select substring('',1,0);

-- pos 0 CHECK
select substring('abc',0);
select substring('abc',0,1);

-- len < 1 CHECK

select substring('abc',1,0.4);
select substring('abc',1,0.5);
select substring('abc',1,0);
select substring('abc',1,-1);

-- POS <0 CHECK
select substring('abc',-1,1);
select substring('abc',-0.5,1);
select substring('abc',-0.4,1);

-- pos excced limit check

select substring('abc',4,3);
select substring('abc',-4,3);


-- pos round CHECK
select substring('abc',0.5,1);
select substring('abc',-0.5,1);
select substring('abc',0.4,1);
select substring('abc',-0.4,1);

-- len round CHECK
select substring('abc',1,0.5);
select substring('abc',1,0.4);

--both pos&len round CHECK
select substring('abc',0.5,0.5);
select substring('abc' ,0.5,0.4);
select substring('abc' ,0.4,0.5);
select substring('abc',0.4,0.4);

-- check wchar
select substring('汉字abc',1);
select substring('汉字abc',1,1);
select substring('汉字abc',-2,2);

--substring check end
DROP EXTENSION myfce;

\c postgres;
DROP DATABASE lttest_mysql_mode_for_substr;
