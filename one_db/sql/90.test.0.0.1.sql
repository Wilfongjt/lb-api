/*
<event-form>
<adopter-form>
<signin-event-form>
<adoptee-form>

| desc | partition key | sort key | data | form |
| ---- | ------ | ------ | -------- | -------- |
*/
------------------------
-- TESTs
------------------------
--      sign('{"aud":"api-client", "iss":"lyttlebit", "sub":false,"user":"guest","scope":["guest"]}','PASSWORDmustBEATLEAST32CHARSLONGLONG'),

\c one_db;

SET search_path TO api_0_0_1, public;

--------------------
-- EVENT_LOGGER Tests
--------------------
BEGIN;

  SELECT plan(1);
  -- TEST: Test event_logger Insert

  SELECT is (
    base_0_0_1.event_logger(
      '{
      "type":"test",
      "name":"some stuff",
      "desc":"more stuff"
      }'::JSONB
    ),
    '{"msg": "OK", "status": "200"}'::JSONB,
    'event_logger - insert test  0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;

-- select sign('{"aud":"api-client", "iss":"lyttlebit", "sub":false,"user":"guest","scope":["guest"]}','PASSWORDmustBEATLEAST32CHARSLONGLONG')

--| Generic event | <request.jwt.claim.jti> | 'event#<guid>' | <type> | <event-form> |
--| Map pan | guest or <request.jwt.claim.jti> | event#<guid> |	pan |
--| Map zoom in | guest or <request.jwt.claim.jti> | event#<guid>	| zoom+ |
--| Map zoom out | guest or <request.jwt.claim.jti> | event#<guid>	| zoom- |
--| Show terms of use | guest or <request.jwt.claim.jti> | event#<guid>	| tou |
--| Initiate forgot password | <request.jwt.claim.jti> | event#<guid>	| forgot |

-- app-token is


-- api_0_0_1.element(JSONB) -- insert(app-body)
-- api_0_0_1.element(JSON, JSON) -- update(criteria, app-body)
-- api_0_0_1.elements(JSON) -- select(criteria)
-- api_0_0_1.elements(JSON) -- delete(critera)

-- api_0_0_1.geography(JSONB) -- insert(app-body)
-- api_0_0_1.geography(JSON, JSON) -- update(criteria, app-body)
-- api_0_0_1.geography(JSON) -- select(criteria)
-- api_0_0_1.geography(JSON) -- delete(critera)

-- api_0_0_1.user(TEXT, JSONB) -- insert(app, app-body)
-- api_0_0_1.user(JSON, JSON) -- update(criteria, app-body)
-- api_0_0_1.users(JSON) -- select(criteria)
-- api_0_0_1.users(JSON) -- delete(critera)
BEGIN;

  SELECT plan(6);
  -- 1
  SELECT is (
    base_0_0_1.changed_key(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              }
        }'::JSONB
    ),
    false,
    'No key changes when form missing key values and displayname changed 0_0_1'::TEXT
  );
  -- 2
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ),
    false,
    'No key changes when form displayname changed 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ),
    true,
    'Detect pk key changes 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ),
    true,
    'Detect sk key changes 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ),
    true,
    'Detect tk key changes 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ),
    true,
    'Detect pk sk tk key changes 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;

--==================
-- Chelate
--==================
/* value found in table
'username#update@user.com',
'const#TEST',
'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
'{"username":"update@user.com",
        "displayname":"J",
        "password":{
          "hash":"4802a10ae464b8c4cd2635c3d7b1ac8a40760ef49101a7a35c2629f6e0a2f2bc51e6a51d4837408be93cf4c2d74bed31fc8c3835a7590e9bd6c9d2533bf496b8",
          "salt":"4b24582a5ae088b8fb6fd3f353d63d6f"
        }
 }
*/
BEGIN;

  SELECT plan(10);

  SELECT ok (
    (base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              }
        }'::JSONB
    ) ->> 'form')::JSONB  = '{"displayname":"k"}'::JSONB,
    'chelate No key changes when form missing key values and displayname changed 0_0_1'::TEXT
  );

  -- chelate prove 'changed' is immutable 0_0_1
  SELECT ok (
    base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              },
        "created":"2021-02-21 20:44:47.442374"
        }'::JSONB
    ) ->> 'created' = '2021-02-21 20:44:47.442374',
    'chelate "changed" is immutable 0_0_1'::TEXT
  );
  SELECT ok (
    base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              },
        "created":"2021-02-21 20:44:47.442374"
        }'::JSONB
    ) ->> 'updated' != '2021-02-21 20:44:47.442374',
    'chelate "updated" is mutable 0_0_1'::TEXT
  );
  -- no pk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk' = 'username#update@user.com',

    'chelate PK changes when form displayname changed 0_0_1'::TEXT
  );
  -- no sk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'sk' = 'const#TEST',

    'chelate SK changes when form displayname changed 0_0_1'::TEXT
  );

  -- no tk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'tk' = 'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
    'chelate TK changes when form displayname changed 0_0_1'::TEXT
  );

  SELECT ok (
    (base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk') = 'username#CHANGEupdate@user.com',

    'chelate Detect pk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'sk' = 'const#CHANGETEST',

    'chelate Detect sk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'tk' = 'guid#CHANGE820a5bd9-e669-41d4-b917-81212bc184a3',

    'chelate Detect tk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk' = 'username#CHANGEupdate@user.com',
    'chelate Detect pk sk tk key changes 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;



-------------------
-- Query
------------------
BEGIN;

  SELECT plan(3);

  SELECT has_table('base_0_0_1', 'one', 'has table');

  SELECT hasnt_pk('base_0_0_1', 'one', 'has no primary key');

  SELECT has_function(
      'api_0_0_1',
      'query',
      ARRAY[ 'JSON' ],
      'Function query (json) should exist'
  );
  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;





  -- Insert
  -- check guid generation
  -- SELECT throws_ok( :sql, :errcode, :ermsg, :description );
BEGIN;

  SELECT plan(8);
  -- {"sk":"const#TEST"}
  -- {"pk":"username#insert2@user.com", "sk":"const#TEST"}
  -- {"sk":"const#TEST", "tk":"guid#a920a5bd9-e669-41d4-b917-81212bc184a3"}
  -- {"pk":"username#insert4@user.com", "sk":"const#TEST", "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3"}

  --  1
  SELECT is (
    base_0_0_1.insert('{
      "sk":"const#TEST",
      "form":{"username":"insert1@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert sk form good 0_0_1'::TEXT
  );
  -- 2
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert2@user.com",
      "sk":"const#TEST",
      "form":{"username":"insert2@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert pk sk form good 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.insert('{
      "sk":"const#TEST",
      "tk":"username#insert22@user.com",
      "form":{"username":"insert22@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert pk sk form good 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.insert('{
      "sk":"const#TEST",
      "tk":"guid#a920a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"insert3@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert sk tk form good  0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert4@user.com",
      "sk":"const#TEST",
      "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"insert4@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'insert pk sk tk form good  0_0_1'::TEXT
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
      }'::JSONB)::JSONB ->> 'msg',
      'Duplicate'::TEXT,
      'insert sk tk form, sk tk duplicte error  0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    base_0_0_1.insert('{
      "form":{"username":"insert@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'insert missing keys form good  0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    base_0_0_1.insert('{
      "pk":"username#insert4@user.com",
      "sk":"const#TEST",
      "tk":"guid#b920a5bd9-e669-41d4-b917-81212bc184a3",
      "badform":{"username":"insert@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'insert pk sk tk BADform   0_0_1'::TEXT
  );



  SELECT * FROM finish();

ROLLBACK;


/*

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

  SELECT plan(14);
  -- 1 pk

  SELECT is (
    base_0_0_1.query('{"pk":"*"}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query pk=* 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"sk":"*"}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query sk=* 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"tk":"*"}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query tk=* 400 0_0_1'::TEXT
  );

  SELECT is (
    base_0_0_1.query('{"pk":""}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query pk="" 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"sk":""}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query sk="" 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"tk":""}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query tk="" 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"pk":"","sk":"*"}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query pk="" sk="" 400 0_0_1'::TEXT
  );
  SELECT is (
    base_0_0_1.query('{"sk":"","tk":""}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query sk="" tk="" 400 0_0_1'::TEXT
  );
  -- 2 pk sk

  SELECT ok (
    base_0_0_1.query('{"pk":"username#existing@user.com", "sk":"const#USER"}'::JSON) ->> 'msg' = 'OK',
    'query pk sk good 0_0_1'::TEXT
  );

  -- 3 pk sk=*

  SELECT ok (
    base_0_0_1.query('{"pk":"username#existing@user.com", "sk":"*"}'::JSON)::JSONB ->> 'msg' = 'OK',
    'query pk sk:* good 0_0_1'::TEXT
  );

  -- 4 sk tk

  SELECT ok (
    base_0_0_1.query('{
      "sk":"const#USER",
      "tk": "guid#420a5bd9-e669-41d4-b917-81212bc184a3"}'::JSON)::JSONB ? 'selection',
    'query sk tk has selection is OK 0_0_1'::TEXT
  );

  -- 5 sk tk=*

  SELECT ok (
    base_0_0_1.query('{"sk":"const#USER", "tk": "*"}'::JSON)::JSONB ->> 'msg' = 'OK',
    'query sk "tk":* good 0_0_1'::TEXT
  );

  -- 6 xk yk

  SELECT ok (
    base_0_0_1.query('{"xk":"const#FLIP", "yk": "guid#920a5bd9-e669-41d4-b917-81212bc184a3"}'::JSON)::JSONB ->> 'msg' = 'OK',
    'query xk yk good 0_0_1'::TEXT
  );

  -- 7 xk yk=*

  SELECT ok (
    base_0_0_1.query('{"xk":"const#FLIP", "yk": "*"}'::JSON)::JSONB ->> 'msg' = 'OK',
    'query xk yk=* good 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;


-- DELETE
BEGIN;

  SELECT plan(5);

  -- {pk:"username#delete@user.com",sk:"const#USER"}
  -- {pk:"usename#nonexisting@user.com",sk:"const#USER"}
  -- Delete returns the deleted item
  -- Delete only acceptes Primary Key combination i.e., pk and sk

  -- 1
  SELECT is (
    base_0_0_1.delete('{
      "xk":"guid#720a5bd9-e669-41d4-b917-81212bc184a3",
      "yk":"const#USER"}'::JSON)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'delete pk sk form, Bad Request 0_0_1'::TEXT
  );
  -- 2
  SELECT is (
    base_0_0_1.delete('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER"
      }'::JSON)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'delete pk sk form,  Not Found 0_0_1'::TEXT
  );
  -- 3
  SELECT ok (
    base_0_0_1.delete('{
      "pk": "username#delete1@user.com",
      "sk":"const#USER"
      }'::JSON)::JSONB ? 'deletion',
    'delete pk sk good 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.delete('{
      "pk":"username#delete2@user.com",
      "sk":"const#USER"
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'delete pk sk form, Ok 0_0_1'::TEXT
  );


  -- 5
  SELECT is (
    base_0_0_1.delete('{
      "sk":"const#USER",
      "tk":"username#delete3@user.com"
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'delete sk tk form, Ok 0_0_1'::TEXT
  );



  SELECT * FROM finish();

ROLLBACK;


  --=======================================
  -- UPDATE
  --=======================================
  -- missing bad keys
BEGIN;

  SELECT plan(4);
  --  1
  SELECT is (
    base_0_0_1.update('{
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'pg update no keys form Bad Request 0_0_1'::TEXT
  );
  -- 2
  SELECT is (
    base_0_0_1.update('{
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'pg update tk only form Bad Request 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.update('{
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'pg update sk tk form Bad Request 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#update@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
      }'::JSON)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'pg update pk sk tk NO form Bad Request 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#unknown820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"unknown@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'pg update pk sk tk form PK Not Found 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#unknown820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"unknown@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'pg update badpk sk tk form PK Not Found 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;


--=======================================
-- UPDATE
--=======================================
-- new keys
-- No change
-- key change
-- form change
-- key and form change

BEGIN;

  SELECT plan(4);

  -- Not Found with a change
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
          "username":"update2@user.com",
          "displayname":"J",
          "const":"USER",
          "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
        }
      }'::JSON)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'PG update Not Found with Change  0_0_1'::TEXT
  );

  -- No change

  SELECT is (
    base_0_0_1.update('{
      "pk":"username#update@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
          "username":"update@user.com",
          "displayname":"J",
          "const":"USER",
          "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
        }
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'PG update No change OK  0_0_1'::TEXT
  );
  -- Form change OK
 SELECT is (
   base_0_0_1.update(
       '{
         "pk":"username#update@user.com",
         "sk":"const#USER",
         "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
         "form":{
                 "username":"update@user.com",
                 "displayname":"K",
                 "const":"USER",
                 "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
               }
        }'::JSON
     )::JSONB ->> 'msg',
     'OK'::TEXT,
     'PG update displayname change OK  0_0_1'::TEXT
 );

 --   Single Key Change only
 SELECT is (
   base_0_0_1.update(
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "username":"CHANGEupdate@user.com",
               "displayname":"J",
               "const":"USER",
               "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
             }
      }'::JSON
     )::JSONB ->> 'msg',
     'OK'::TEXT,
     'PG update pk key change OK  0_0_1'::TEXT
 );
 --   Multiple Key Change
 SELECT is (
   base_0_0_1.update(
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "username":"CHANGEupdate@user.com",
               "displayname":"J",
               "const":"CHANGETEST",
               "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
             }
      }'::JSON
     )::JSONB ->> 'msg',
     'Not Found'::TEXT,
     'PG update, DOUBLE PUMP on an update 0_0_1'::TEXT
 );

  SELECT * FROM finish();

ROLLBACK;

-------------------
-- SIGNIN
------------------
BEGIN;

  SELECT plan(8);
  -- 1
  SELECT has_function(
      'api_0_0_1',
      'signin',
      ARRAY[ 'TEXT', 'JSON' ],
      'Function signin (text, json) should exist'
  );
  -- 2
  SELECT is (
    api_0_0_1.signin(
      NULL::TEXT,
      NULL::JSON
    )::JSONB ->> 'msg',
    'Forbidden'::TEXT,
    'signin NO token, NO credentials, Forbidden 0_0_1'::TEXT
  );
    -- 3
  SELECT is (
    api_0_0_1.signin(
      'bad.token.jjj'::TEXT,
      NULL::JSON
    )::JSONB ->> 'msg',
    'Forbidden'::TEXT,
    'signin token BAD, NO credentials, Forbidden 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    api_0_0_1.signin(
      NULL::TEXT,
      '{"username":"existing@user.com",
        "password":"a1A!aaaa"
       }'::JSON)::JSONB ->> 'msg',
    'Forbidden'::TEXT,
    'signin NO token, GOOD credentials,  Forbidden 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    api_0_0_1.signin(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"unknown@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'msg',
    'Not Found'::TEXT,
    'signin GOOD token Bad Username Credentials 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    api_0_0_1.signin(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"existing@user.com","password":"unknown"}'::JSON
    )::JSONB ->> 'msg',
    'Not Found'::TEXT,
    'signin GOOD token BAD Password Credentials 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    api_0_0_1.signin(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"existing@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'msg',
    'OK'::TEXT,
    'signin GOOD token GOOD Credentials 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    api_0_0_1.signin(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"existing@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB ? 'token',
    true::Boolean,
    'signin GOOD token GOOD Credentials Returns TOKEN 0_0_1'::TEXT
  );
  -- 9

  -- TOKEN TESTS

  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;

-- user_ins
-- user_upd
-- user_sel
-- user_del


-------------------
-- User_ins
------------------
BEGIN;

  SELECT plan(4);
  -- 1
  SELECT has_function(
      'api_0_0_1',
      'user_ins',
      ARRAY[ 'TEXT', 'JSON' ],
      'Function user_ins (text, json) should exist'
  );
  -- 2
  SELECT is (
    api_0_0_1.user_ins(
      NULL::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_ins(NULL,NULL) 403 0_0_1'::TEXT
  );
  -- 3

  SELECT is (
    api_0_0_1.user_ins(
      'xxx'::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_ins(bad_token,NULL) 403 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,NULL) 400 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{}) 400 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":""}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk:""}) 400 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"","sk":""}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk:"",sk:""}) 400 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.lb_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#goodinsert@user.com","sk":"const#USER","form":{}}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'user_ins(token,{pk:"username#goodinsert@user.com",sk:"const#USER", form:{}}) 200 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
-------------------
-- User_ins
------------------
BEGIN;

  SELECT plan(4);
  -- 1
  SELECT has_function(
      'api_0_0_1',
      'user_upd',
      ARRAY[ 'TEXT', 'JSON', 'JSON' ],
      'Function user_upd (text, json, json) should exist'
  );

  SELECT * FROM finish();

ROLLBACK;
/*
-------------------
-- Adopter TESTs
-------------------

--| add adopter  | <request.jwt.claim.jti> | 'profile#<request.jwt.claim.jti>' | <type> | <adopter-form> |

BEGIN;

  SELECT plan(2);
  -- TEST: Test(a) adopter Insert

  SELECT ok (
    api_0_0_1.adopter('{
      "name":  "me@someplace.com",
      "displayname", "J",
      "password": "a1A!aaaa"
      }'::JSON
    )::JSONB ->> 'status' = '200','adopter - new adopter 0_0_1'
  );

  -- duplicate adopter
-- PREPARE duplicate_adopter AS api_0_0_1.adopter('{"name":  "me@someplace.com", "password": "a1A!aaaa"}'::JSON);
PREPARE new_adopter as select api_0_0_1.adopter('{"name":  "me@someplace.com", "password": "a1A!aaaa"}'::JSON);

SELECT throws_ok(
    'new_adopter',
    'PT409',
    'Conflict',
    'We should get a unique violation for a duplicate PK'
);

--Adpotees needs a test ... unable to get one working for function's return type


SELECT * FROM finish();

ROLLBACK;
*/


-------------------
-- SIGNIN Tests
-------------------
/*
BEGIN;

  SELECT plan(2);
   -- signin bad user
   -- singin good user bad password
   -- signin good user good password

-- TEST: Test(b) signin Insert

--| signin sucess | <guest> | 'event#<guid>' | 'signin' | <signin-form> |

SELECT ok (
  api_0_0_1.signin('{
    "name":  "existing@user.com",
    "password": "a1A!aaaa"
    }'::JSON
  )::JSONB ? 'token',
  'signin good user good password returns token 0_0_1'
);


SELECT * FROM finish();

ROLLBACK;

*/
/*

-------------------
-- Adoptee TESTs
-------------------

BEGIN;

  SELECT plan(4);

-- TEST: Test(a) adopter Insert

--| adoptee success | <request.jwt.claim.jti> | 'adoptee#<dr-asset-id>' | 'adoptee' | <adoptee-form> |
-- INSERT
SELECT is (
  api_0_0_1.adoptee( '{
    "name":"some opt name",
    "drain_id":"GR_40089457",
    "lat":42.96265175640001,
    "lon":-85.6676956307}
    '::JSON
  ),
  '{"msg": "OK", "status": 200, "data":{"id": "GR_40089457", "lat": 42.96265175640001, "lon": -85.6676956307, "name": "some opt name", "type": "adoptee", "drain_id": "GR_40089457", "adopter_key": "8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"}}'::JSONB,
  'adoptee - insert test 0_0_1'::TEXT
);
-- '{"name":"some opt name", "drain_id":"GR_40089457","lat":42.96265175640001,"lon":-85.6676956307}'
-- DUPLICATE
PREPARE new_adoptee AS select api_0_0_1.adoptee( '{
  "name":"some opt name",
  "drain_id":"GR_40089457",
  "lat":42.96265175640001,
  "lon":-85.6676956307}'::JSON
);
SELECT throws_ok(
    'new_adoptee',
    'PT409',
    'Conflict',
    'We should get a unique violation for a duplicate PK'
);
-- UPDATE
-- testing key "adopter_key":"8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"
SELECT is (
  api_0_0_1.adoptee( '{
    "id":"GR_40089457",
    "name":"abc-asd",
    "drain_id":"GR_40089457",
    "lat":42.96265175640001,
    "lon":-85.6676956307,
    "adopter_key":"8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"
    }'::JSON
  ),
  '{"msg": "OK", "data": {"id":"GR_40089457", "lat": 42.96265175640001, "lon": -85.6676956307, "name": "abc-asd", "type": "adoptee", "drain_id": "GR_40089457","adopter_key": "8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"}, "status": 200}'::JSONB,
  'adoptee - insert test 0_0_1'::TEXT
);
-- DELETE
SELECT is (
  api_0_0_1.adoptee( '{
    "id":"-GR_40089457",
    "name":"some opt name",
    "drain_id":"GR_40089457",
    "lat":42.96265175640001,
    "lon":-85.6676956307,
    "adopter_key":"8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"
    }'::JSON
  ),
  '{"msg": "OK", "data": {"id": "-GR_40089457", "lat": 42.96265175640001, "lon": -85.6676956307, "name": "some opt name", "type": "adoptee", "drain_id": "GR_40089457", "adopter_key": "8a39dc33-0c6c-4b4e-bdb8-3829af311dd8"}, "status": 200}'::JSONB,
  'adoptee - delete test 0_0_1'::TEXT
);

SELECT * FROM finish();

ROLLBACK;
*/
