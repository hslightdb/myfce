-- mysql json API

CREATE FUNCTION mysql.json_pretty(jsonb)
    RETURNS text AS
'select jsonb_pretty($1);'
LANGUAGE SQL;
COMMENT ON FUNCTION mysql.json_pretty(jsonb) IS 'Provides pretty-printing of JSON values similar to that implemented in PHP and by other languages and database systems.';

CREATE FUNCTION mysql.json_array()
    RETURNS jsonb AS
'select jsonb_build_array();'
LANGUAGE SQL;
COMMENT ON FUNCTION mysql.json_array() IS 'Evaluates a empty list of values and returns a JSON array containing those values.';

CREATE FUNCTION mysql.json_object()
    RETURNS jsonb
AS
'select jsonb_build_object();'
LANGUAGE SQL;
COMMENT ON FUNCTION mysql.json_object() IS 'Evaluates a empty list of key-value pairs and returns a JSON object containing those pairs.';


CREATE FUNCTION mysql.json_array(variadic "any")
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_array'
LANGUAGE C IMMUTABLE;
COMMENT ON FUNCTION mysql.json_array(variadic "any") IS 'Evaluates a list of values and returns a JSON array containing those values.';

CREATE FUNCTION mysql.json_object(variadic "any")
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_object'
LANGUAGE C IMMUTABLE;
COMMENT ON FUNCTION mysql.json_object(variadic "any") IS 'Evaluates a list of key-value pairs and returns a JSON object containing those pairs.';

CREATE FUNCTION mysql.json_extract(jsonb, jsonpath)
    RETURNS jsonb
AS 'MODULE_PATHNAME', 'myfce_json_extract'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.json_extract(jsonb, jsonpath) IS 'Returns data from a JSON document, selected from the parts of the document matched by the path argument.';

CREATE FUNCTION mysql.json_contains(jsonb, jsonb, jsonpath)
    RETURNS bool AS
$$
    select jsonb_eq(mysql.json_extract($1, $3), $2);
$$
LANGUAGE SQL;
COMMENT ON FUNCTION mysql.json_contains(jsonb, jsonb, jsonpath) IS 'Indicates by returning true or false whether a given candidate JSON document is contained within a target JSON document.';

CREATE FUNCTION mysql.json_contains_path(jsonb, text, variadic jsonpath[])
    RETURNS bool
AS 'MODULE_PATHNAME', 'myfce_json_contains_path'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.json_contains_path(jsonb, text, variadic jsonpath[]) IS 'Indicates by returning true or false whether a given candidate JSON document is contained within a target JSON document.';

