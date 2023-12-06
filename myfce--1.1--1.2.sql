
-- mysql str_to_date
create function mysql.str_to_date2(text,text)
returns date  AS 'MODULE_PATHNAME','myfce_str_to_date2' language c STRICT IMMUTABLE PARALLEL SAFE;

create function mysql.str_to_date3(text,text)
returns time  AS 'MODULE_PATHNAME','myfce_str_to_date3' language c STRICT IMMUTABLE PARALLEL SAFE;


-- mysql divide
-- int4 div int4,int2,int8
create function mysql.int4_int4_div(v1 int4, v2 int4) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int4_int2_div(v1 int4, v2 int2) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int4_int8_div(v1 int4, v2 int8) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

-- int2 div int2,int4,int8
create function mysql.int2_int2_div(v1 int2, v2 int2) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int2_int4_div(v1 int2, v2 int4) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int2_int8_div(v1 int2, v2 int8) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

-- int8 div int2,int4,int8
create function mysql.int8_int8_div(v1 int8, v2 int8) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int8_int2_div(v1 int8, v2 int2) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int8_int4_div(v1 int8, v2 int4) returns numeric
as
$$
select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

-- operator / 
-- operator int4 /
create operator mysql./ (
	leftarg   = int4,
	rightarg  = int4,
	procedure = mysql.int4_int4_div
);

create operator mysql./ (
	leftarg   = int4,
	rightarg  = int2,
	procedure = mysql.int4_int2_div
);

create operator mysql./ (
	leftarg   = int4,
	rightarg  = int8,
	procedure = mysql.int4_int8_div
);

-- operator int2 /
create operator mysql./ (
	leftarg   = int2,
	rightarg  = int2,
	procedure = mysql.int2_int2_div
);

create operator mysql./ (
	leftarg   = int2,
	rightarg  = int4,
	procedure = mysql.int2_int4_div
);

create operator mysql./ (
	leftarg   = int2,
	rightarg  = int8,
	procedure = mysql.int2_int8_div
);

-- operator int8 /
create operator mysql./ (
	leftarg   = int8,
	rightarg  = int8,
	procedure = mysql.int8_int8_div
);

create operator mysql./ (
	leftarg   = int8,
	rightarg  = int2,
	procedure = mysql.int8_int2_div
);

create operator mysql./ (
	leftarg   = int8,
	rightarg  = int4,
	procedure = mysql.int8_int4_div
);

-- mysql text div
create function mysql.int2_text_div(v1 int2, v2 text) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int4_text_div(v1 int4, v2 text) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.int8_text_div(v1 int8, v2 text) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.text_int2_div(v1 text, v2 int2) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.text_int4_div(v1 text, v2 int4) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.text_int8_div(v1 text, v2 int8) returns numeric
as
$$
  select cast(v1 as numeric) / cast(v2 as numeric);
$$
language sql immutable;

create function mysql.text_numeric_div(v1 text, v2 numeric) returns numeric
as
$$
  select cast(v1 as numeric) / v2;
$$
language sql immutable;

create function mysql.numeric_text_div(v1 numeric, v2 text) returns numeric
as
$$
  select v1 / cast(v2 as numeric);
$$
language sql immutable;

create operator mysql./ (
  leftarg   = int2,
  rightarg  = text,
  procedure = mysql.int2_text_div
);

create operator mysql./ (
  leftarg   = int4,
  rightarg  = text,
  procedure = mysql.int4_text_div
);

create operator mysql./ (
  leftarg   = int8,
  rightarg  = text,
  procedure = mysql.int8_text_div
);

create operator mysql./ (
  leftarg   = text,
  rightarg  = int2,
  procedure = mysql.text_int2_div
);

create operator mysql./ (
  leftarg   = text,
  rightarg  = int4,
  procedure = mysql.text_int4_div
);

create operator mysql./ (
  leftarg   = text,
  rightarg  = int8,
  procedure = mysql.text_int8_div
);

create operator mysql./ (
  leftarg   = text,
  rightarg  = numeric,
  procedure = mysql.text_numeric_div
);

create operator mysql./ (
  leftarg   = numeric,
  rightarg  = text,
  procedure = mysql.numeric_text_div
);



-- mysql for substr,substring

CREATE FUNCTION mysql.substr(str text, pos int)
RETURNS text
AS 'MODULE_PATHNAME','mysql_substr2'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.substr(text, int) IS 'Returns substring started on pos to end';

-- explicitly do conv for numeric -> int
CREATE FUNCTION mysql.substr(str text, pos numeric)
RETURNs text AS
$$
    SELECT mysql.substr($1::text,trunc($2,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substr(text, numeric) IS 'Returns substring started on pos to end';

CREATE FUNCTION mysql.substr(str text, pos int, len int)
RETURNS text
AS 'MODULE_PATHNAME','mysql_substr3'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION mysql.substr(text, int,int) IS 'Returns substring started on pos to end, with a maximum len chars of len';

CREATE FUNCTION mysql.substr(str text, pos numeric, len int)
RETURNs text AS
$$
    SELECT mysql.substr($1::text,trunc($2,1)::int, $3::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substr(text,numeric,int) IS 'Returns substring started on pos, with a maximum len chars of len';

CREATE FUNCTION mysql.substr(str text, pos int, len numeric)
RETURNs text AS
$$
    SELECT mysql.substr($1::text,$2::int, trunc($3,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substr(text,int,numeric) IS 'Returns substring started on pos, with a maximum len chars of len';

CREATE FUNCTION mysql.substr(str text, pos numeric, len numeric)
RETURNs text AS
$$
    SELECT mysql.substr($1::text,trunc($2,1)::int, trunc($3,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substr(text,numeric,numeric) IS 'Returns substring started on pos, with a maximum len chars of len';

-- mysql.substring(text,int|numeric) begin
CREATE FUNCTION mysql.substring(str text, pos int)
RETURNS text AS
$$
    SELECT mysql.substr($1::text,$2::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, int) IS 'Returns substring started on pos to end';

CREATE FUNCTION mysql.substring(str text, pos numeric)
RETURNs text AS
$$
    SELECT mysql.substr($1::text,trunc($2,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, numeric) IS 'Returns substring started on pos to end';
-- mysql.substring(text,int|numeric) end

--mysql.substring(text,int|numeric,int|numeric) begin
CREATE FUNCTION mysql.substring(str text, pos int, len int)
RETURNS text AS
$$
    SELECT mysql.substr($1::text,$2::int, $3::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, int, int) IS 'Returns substring started on pos, with a maximum len chars of len';

CREATE FUNCTION mysql.substring(str text, pos numeric, len int)
RETURNS text AS
$$
    SELECT mysql.substr($1::text, trunc($2,1)::int, $3::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, numeric, int) IS 'Returns substring started on pos, with a maximum len chars of len';

CREATE FUNCTION mysql.substring(str text, pos int, len numeric)
RETURNS text AS
$$
    SELECT mysql.substr($1::text, $2::int, trunc($3,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, int, numeric) IS 'Returns substring started on pos, with a maximum len chars of len';

CREATE FUNCTION mysql.substring(str text, pos numeric, len numeric)
RETURNS text AS
$$
    SELECT mysql.substr($1::text, trunc($2,1)::int, trunc($3,1)::int);
$$
LANGUAGE SQL IMMUTABLE;
COMMENT ON FUNCTION mysql.substring(text, numeric, numeric) IS 'Returns substring started on pos, with a maximum len chars of len';
--mysql.substring(text,int|numeric,int|numeric) end