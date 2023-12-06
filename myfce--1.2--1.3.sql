--mysql for sysdate()

CREATE FUNCTION mysql.sysdate()
RETURNS timestamp(0)
AS 'MODULE_PATHNAME','myfce_sysdate_0'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.sysdate() IS 'returns the time at which it executes';

--CREATE FUNCTION mysql.sysdate(fsp int)
--RETURNS timestamp(0)
--AS 'MODULE_PATHNAME','myfce_sysdate_1'
--LANGUAGE C IMMUTABLE STRICT;
--COMMENT ON FUNCTION mysql.sysdate(fsp int) IS 'returns the time at which it executes, fsp is a precision parameter';


REVOKE ALL ON mysql.dual FROM PUBLIC;
GRANT SELECT, REFERENCES ON mysql.dual TO PUBLIC;