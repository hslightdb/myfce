-- mysql json API

CREATE FUNCTION mysql.json_remove(jsonb, jsonpath)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_remove'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.json_remove(jsonb, jsonpath) IS
    'Removes data from a JSON document and returns the result.';


CREATE FUNCTION mysql.json_insert(jsonb, jsonpath, anyelement)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_insert'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.json_insert(jsonb, jsonpath, anyelement) IS
    'Inserts data into a JSON document and returns the result. Returns NULL if any argument is NULL.';

CREATE FUNCTION mysql.json_insert(jsonb, jsonpath, text)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_insert'
LANGUAGE C IMMUTABLE; -- NOT STRICT
COMMENT ON FUNCTION mysql.json_insert(jsonb, jsonpath, anyelement) IS
    'Inserts data into a JSON document and returns the result. Returns NULL if any argument is NULL.';


CREATE FUNCTION mysql.json_replace(jsonb, jsonpath, anyelement)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_replace'
LANGUAGE C IMMUTABLE; -- NOT STRICT
COMMENT ON FUNCTION mysql.json_replace(jsonb, jsonpath, anyelement) IS
    'Replaces existing values in a JSON document and returns the result. Returns NULL if any argument is NULL.';

CREATE FUNCTION mysql.json_replace(jsonb, jsonpath, text)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_replace'
LANGUAGE C IMMUTABLE; -- NOT STRICT
COMMENT ON FUNCTION mysql.json_replace(jsonb, jsonpath, text) IS
    'Replaces existing values in a JSON document and returns the result. Returns NULL if any argument is NULL.';


CREATE FUNCTION mysql.json_set(jsonb, jsonpath, anyelement)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_set'
LANGUAGE C IMMUTABLE; -- NOT STRICT
COMMENT ON FUNCTION mysql.json_set(jsonb, jsonpath, anyelement) IS
    'Inserts or updates data in a JSON document and returns the result. Returns NULL if json_doc or path is NULL.';

CREATE FUNCTION mysql.json_set(jsonb, jsonpath, text)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_set'
LANGUAGE C IMMUTABLE; -- NOT STRICT
COMMENT ON FUNCTION mysql.json_set(jsonb, jsonpath, text) IS
    'Inserts or updates data in a JSON document and returns the result. Returns NULL if json_doc or path is NULL';
