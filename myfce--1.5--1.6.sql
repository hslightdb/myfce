CREATE FUNCTION mysql.varchar_bool_equal(varchar, boolean)
    RETURNS boolean
AS 'MODULE_PATHNAME', 'text_bool_equal'
LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR mysql.= (
    LEFTARG    = varchar,
    RIGHTARG   = boolean,
    PROCEDURE  = mysql.varchar_bool_equal,
    RESTRICT   = eqsel,
    JOIN       = eqjoinsel,
    HASHES, MERGES
);

CREATE FUNCTION mysql.varchar_bool_not_equal(varchar, boolean)
    RETURNS boolean
AS 'MODULE_PATHNAME', 'text_bool_not_equal'
LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR mysql.!= (
    LEFTARG    = varchar,
    RIGHTARG   = boolean,
    PROCEDURE  = mysql.varchar_bool_not_equal,
    RESTRICT   = neqsel,
    JOIN       = neqjoinsel,
    HASHES, MERGES
);