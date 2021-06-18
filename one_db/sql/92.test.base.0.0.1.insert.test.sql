
\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;



/*
 _                     _
(_)                   | |
 _ _ __  ___  ___ _ __| |_
| | '_ \/ __|/ _ \ '__| __|
| | | | \__ \  __/ |  | |_
|_|_| |_|___/\___|_|   \__|

*/

  -- Insert
  -- check guid generation
  -- SELECT throws_ok( :sql, :errcode, :ermsg, :description );
BEGIN;

  SELECT plan(9);
  -- {"sk":"const#TEST"}
  -- {"pk":"username#insert2@user.com", "sk":"const#TEST"}
  -- {"sk":"const#TEST", "tk":"guid#a920a5bd9-e669-41d4-b917-81212bc184a3"}
  -- {"pk":"username#insert4@user.com", "sk":"const#TEST", "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3"}
  --\set owner_id 0
  select set_config('request.jwt.claim.key', '1', true); -- If is_local is true, the new value will only apply for the current transaction.

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'insert',
      ARRAY[ 'JSONB','TEXT' ],
      'Function Insert (_chelate JSONB, text) exists'
  );

  --  2
  SELECT is (
    (base_0_0_1.insert('{
      "sk":"const#TEST",
      "form":{"username":"insert1@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert1Owner')::JSONB - 'insertion'),
      '{"msg": "OK", "status": "200"}'::JSONB,
      'insert sk form good 0_0_1'::TEXT
  );

  -- 3
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert2@user.com",
      "sk":"const#TEST",
      "form":{"username":"insert2@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert2Owner')::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert pk sk form good 0_0_1'::TEXT
  );

  -- 4
  SELECT is (
    (base_0_0_1.insert('{
      "sk":"const#TEST",
      "tk":"username#insert22@user.com",
      "form":{"username":"insert22@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert22Owner')::JSONB - 'insertion'),
      '{"msg": "OK", "status": "200"}'::JSONB,
      'insert pk sk form good 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.insert('{
      "sk":"const#TEST",
      "tk":"guid#a920a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"insert3@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert3Owner')::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert sk tk form good  0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert4@user.com",
      "sk":"const#TEST",
      "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"insert4@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert4Owner')::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert pk sk tk form good  0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert4@user.com",
      "sk":"const#TEST",
      "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"insert4@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert4Owner')::JSONB ->> 'msg',
      'Duplicate'::TEXT,
      'insert sk tk form, sk tk duplicte error  0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    base_0_0_1.insert('{
      "form":{"username":"insert@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insertOwner')::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'insert missing keys form good  0_0_1'::TEXT
  );
  -- 9
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert4@user.com",
      "sk":"const#TEST",
      "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3",
      "badform":{"username":"insert@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB,
      'insert4Owner')::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'insert pk sk tk BADform   0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;
