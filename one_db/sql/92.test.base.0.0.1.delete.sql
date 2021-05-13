
\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
Delete
     _      _      _
    | |    | |    | |
  __| | ___| | ___| |_ ___
 / _` |/ _ \ |/ _ \ __/ _ \
| (_| |  __/ |  __/ ||  __/
 \__,_|\___|_|\___|\__\___|

*/
-- DELETE
BEGIN;

  SELECT plan(5);

  -- {pk:"username#delete@user.com",sk:"const#USER"}
  -- {pk:"usename#nonexisting@user.com",sk:"const#USER"}
  -- Delete returns the deleted item
  -- Delete only acceptes Primary Key combination i.e., pk and sk
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'delete',
      ARRAY[ 'JSONB' ],
      'Function Delete (jsonb) exists'
  );
  -- 2
  SELECT is (
    base_0_0_1.delete('{
      "xk":"guid#720a5bd9-e669-41d4-b917-81212bc184a3",
      "yk":"const#USER"}'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'delete pk sk form, Bad Request 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.delete('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER"
      }'::JSONB)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'delete pk sk form,  Not Found 0_0_1'::TEXT
  );
  -- 4
  SELECT ok (
    base_0_0_1.delete('{
      "pk": "username#delete1@user.com",
      "sk":"const#USER"
      }'::JSONB)::JSONB ? 'deletion',
    'delete pk sk good 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.delete('{
      "pk":"username#delete2@user.com",
      "sk":"const#USER"
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'delete pk sk form, Ok 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;
