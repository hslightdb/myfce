CREATE DATABASE lttest_none_mysql_mode WITH lightdb_syntax_compatible_type 'off';
\c lttest_none_mysql_mode
--should prompt with a error
select sysdate();

CREATE DATABASE lttest_mysql_mode_for_sysdate WITH lightdb_syntax_compatible_type 'mysql';
\c lttest_mysql_mode_for_sysdate;

--should prompt with error
select sysdate(2);

show lightdb_dblevel_syntax_compatible_type;
CREATE EXTENSION IF NOT EXISTS myfce;

CREATE TABLE lttest_t_mysql_sysdate_test(ts timestamp(0));

BEGIN;
    INSERT INTO lttest_t_mysql_sysdate_test VALUES( sysdate() );
    SELECT pg_sleep(2);
    INSERT INTO lttest_t_mysql_sysdate_test VALUES( sysdate() );
    SELECT COUNT(DISTINCT ts) FROM lttest_t_mysql_sysdate_test;
END;
DROP TABLE lttest_t_mysql_sysdate_test;

CREATE TABLE lttest_t_mysql_sysdate_test(ts timestamp(0));
BEGIN;
    INSERT INTO lttest_t_mysql_sysdate_test VALUES( mysql.sysdate() );
    SELECT pg_sleep(2);
    INSERT INTO lttest_t_mysql_sysdate_test VALUES( mysql.sysdate() );
    SELECT COUNT(DISTINCT ts) FROM lttest_t_mysql_sysdate_test;
END;

--check sysdate availablity (should not be affacted by new feature)
INSERT INTO lttest_t_mysql_sysdate_test VALUES(sysdate);

DROP TABLE lttest_t_mysql_sysdate_test;

CREATE OR REPLACE FUNCTION lttest_t_mysql_sysdate_assign_check()
RETURNS BOOLEAN
AS $$
    DECLARE
        ts_begin    timestamp ;
        ts_end      timestamp ;
        rt_exceed_2s    BOOLEAN;
    BEGIN
        ts_begin := mysql.sysdate();
        PERFORM 'select pg_sleep(2);';
        ts_end = mysql.sysdate();
        
        select (ts_end >= ts_begin) INTO rt_exceed_2s;
        return rt_exceed_2s;
    END
$$
LANGUAGE plpgsql;

SELECT lttest_t_mysql_sysdate_assign_check();
DROP FUNCTION lttest_t_mysql_sysdate_assign_check();

--should result in all t
CREATE OR REPLACE FUNCTION lttest_t_mysql_sysdate_add_sub_check()
RETURNS TABLE
    (
        Y_ADD_1 BOOLEAN,
        Y_SUB_1 BOOLEAN,
        M_ADD_1 BOOLEAN,
        M_SUB_1 BOOLEAN,
        D_ADD_1 BOOLEAN,
        D_SUB_1 BOOLEAN,
        H_ADD_1 BOOLEAN,
        H_SUB_1 BOOLEAN,
        mm_ADD_1 BOOLEAN,
        mm_SUB_1 BOOLEAN,
        s_ADD_1 BOOLEAN,
        s_sub_1 BOOLEAN
    )
AS $$
    DECLARE
        ts_begin    timestamp ;
        ts_end      timestamp ;

        rt_Y_ADD_1 BOOLEAN;
        rt_Y_SUB_1 BOOLEAN;
        rt_M_ADD_1 BOOLEAN;
        rt_M_SUB_1 BOOLEAN;
        rt_D_ADD_1 BOOLEAN;
        rt_D_SUB_1 BOOLEAN;
        rt_H_ADD_1 BOOLEAN;
        rt_H_SUB_1 BOOLEAN;
        rt_mm_ADD_1 BOOLEAN;
        rt_mm_SUB_1 BOOLEAN;
        rt_s_ADD_1 BOOLEAN;
        rt_s_sub_1 BOOLEAN;

    BEGIN
        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 year;
        SELECT ((ts_end - ts_begin) >= interval 1 year) INTO rt_Y_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 year;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 year) INTO rt_Y_SUB_1;

        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 month;
        SELECT ((ts_end - ts_begin) >= interval 1 month) INTO rt_M_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 month;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 month) INTO rt_M_SUB_1;

        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 day;
        SELECT ((ts_end - ts_begin) >= interval 1 day) INTO rt_D_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 day;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 day) INTO rt_D_SUB_1;

        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 hour;
        SELECT ((ts_end - ts_begin) >= interval 1 hour) INTO rt_H_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 hour;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 hour) INTO rt_H_SUB_1;

        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 minute;
        SELECT ((ts_end - ts_begin) >= interval 1 minute) INTO rt_mm_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 minute;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 minute) INTO rt_mm_SUB_1;

        ts_begin := mysql.sysdate();
        ts_end := mysql.sysdate() + interval 1 second;
        SELECT ((ts_end - ts_begin) >= interval 1 second) INTO rt_s_ADD_1;

        ts_begin := mysql.sysdate() - interval 1 second;
        ts_end := mysql.sysdate() ;
        SELECT ((ts_end - ts_begin) >= interval 1 second) INTO rt_s_SUB_1;

        return QUERY SELECT
            rt_Y_ADD_1,
            rt_Y_SUB_1,
            rt_M_ADD_1,
            rt_M_SUB_1,
            rt_D_ADD_1,
            rt_D_SUB_1,
            rt_H_ADD_1,
            rt_H_SUB_1,
            rt_mm_ADD_1,
            rt_mm_SUB_1,
            rt_s_ADD_1,
            rt_s_SUB_1
                ;
    END
$$
LANGUAGE plpgsql;

SELECT lttest_t_mysql_sysdate_add_sub_check();
DROP FUNCTION lttest_t_mysql_sysdate_add_sub_check();

--check end
DROP EXTENSION myfce;

\c postgres;
DROP DATABASE lttest_mysql_mode_for_sysdate;
DROP DATABASE lttest_none_mysql_mode;