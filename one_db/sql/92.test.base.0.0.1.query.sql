\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;



/*


  __ _ _   _  ___ _ __ _   _
 / _` | | | |/ _ \ '__| | | |
| (_| | |_| |  __/ |  | |_| |
 \__, |\__,_|\___|_|   \__, |
    | |                 __/ |
    |_|                |___/


GOOD
pk   sk
pk   sk=*
     sk   tk
     sk   tk=*
     xk   yk
     xk=* yk
BAD
pk=""
pk=*
sk=""
sk=*
tk=""
tk=*

pk=""
pk="" sk=""
pk="*" sk="*"
      sk="" tk=""
      xk="" yk=""
*/
BEGIN;

  SELECT plan(15);
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'query',
      ARRAY[ 'JSONB' ],
      'Function query (json) should exist'
  );
  -- 2 pk

  SELECT is (
    base_0_0_1.query('{"pk":"*"}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query pk=* 400 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.query('{"sk":"*"}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query sk=* 400 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.query('{"tk":"*"}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query tk=* 400 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.query('{"pk":""}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query pk="" 400 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    base_0_0_1.query('{"sk":""}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query sk="" 400 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    base_0_0_1.query('{"tk":""}'::JSONB),
    '{"msg": "Bad Request", "extra": "42703", "status": "400"}'::JSONB,
    'query tk="" 400 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    base_0_0_1.query('{"pk":"","sk":"*"}'::JSONB),
    '{"msg": "Not Found", "status": "404"}'::JSONB,
    'query pk="" sk="*" 404 0_0_1'::TEXT
  );
  -- 9
  SELECT is (
    base_0_0_1.query('{"sk":"","tk":""}'::JSONB),
    '{"msg": "Not Found", "status": "404"}'::JSONB,
    'query sk="" tk="" 404 0_0_1'::TEXT
  );
  -- 10 pk sk

  SELECT ok (
    base_0_0_1.query('{"pk":"username#existing@user.com", "sk":"const#USER"}'::JSONB) ->> 'msg' = 'OK',
    'query pk sk good 0_0_1'::TEXT
  );

  -- 11 pk sk=*

  SELECT ok (
    base_0_0_1.query('{"pk":"username#existing@user.com", "sk":"*"}'::JSONB)::JSONB ->> 'msg' = 'OK',
    'query pk sk:* good 0_0_1'::TEXT
  );

  -- 12 sk tk

  SELECT ok (
    base_0_0_1.query('{
      "sk":"const#USER",
      "tk": "guid#420a5bd9-e669-41d4-b917-81212bc184a3"}'::JSONB)::JSONB ? 'selection',
    'query sk tk has selection is OK 0_0_1'::TEXT
  );

  -- 13 sk tk=*

  SELECT ok (
    base_0_0_1.query('{"sk":"const#USER", "tk": "*"}'::JSONB)::JSONB ->> 'msg' = 'OK',
    'query sk "tk":* good 0_0_1'::TEXT
  );

  -- 14 xk yk

  SELECT ok (
    base_0_0_1.query('{"xk":"const#FLIP", "yk": "guid#920a5bd9-e669-41d4-b917-81212bc184a3"}'::JSONB)::JSONB ->> 'msg' = 'OK',
    'query xk yk good 0_0_1'::TEXT
  );

  -- 15 xk yk=*

  SELECT ok (
    base_0_0_1.query('{"xk":"const#FLIP", "yk": "*"}'::JSONB)::JSONB ->> 'msg' = 'OK',
    'query xk yk=* good 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;
