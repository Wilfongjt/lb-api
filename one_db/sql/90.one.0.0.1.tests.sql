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

SET search_path TO one_version_0_0_1, public;

--------------------
-- EVENT_LOGGER Tests
--------------------
BEGIN;

  SELECT plan(1);
  -- TEST: Test event_logger Insert

  SELECT is (
    one_base.event_logger(
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
/*
BEGIN;

  SELECT plan(1);
  -- TEST: Test event_logger Insert
  SELECT is (
    one_base.insert(
      'xxxx',
      '{
        pk:"username#abc@xyz.com",
        sk:"displayname#abc",
        tk:"password#a1A!aaaa",
        form:{username:"abc@xyz.com",displayname:"abc","password":"a1A!aaaa"}
      }'::JSONB
    ),
    '{"msg": "Malformed Token", "status": "403"}'::JSONB,
    'event_logger - insert test  0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
*/
--| Generic event | <request.jwt.claim.jti> | 'event#<guid>' | <type> | <event-form> |
--| Map pan | guest or <request.jwt.claim.jti> | event#<guid> |	pan |
--| Map zoom in | guest or <request.jwt.claim.jti> | event#<guid>	| zoom+ |
--| Map zoom out | guest or <request.jwt.claim.jti> | event#<guid>	| zoom- |
--| Show terms of use | guest or <request.jwt.claim.jti> | event#<guid>	| tou |
--| Initiate forgot password | <request.jwt.claim.jti> | event#<guid>	| forgot |

-- app-token is


-- one_version_0_0_1.element(JSON) -- insert(app-body)
-- one_version_0_0_1.element(JSON, JSON) -- update(criteria, app-body)
-- one_version_0_0_1.elements(JSON) -- select(criteria)
-- one_version_0_0_1.elements(JSON) -- delete(critera)

-- one_version_0_0_1.geography(JSON) -- insert(app-body)
-- one_version_0_0_1.geography(JSON, JSON) -- update(criteria, app-body)
-- one_version_0_0_1.geography(JSON) -- select(criteria)
-- one_version_0_0_1.geography(JSON) -- delete(critera)

-- one_version_0_0_1.user(TEXT, JSON) -- insert(app, app-body)
-- one_version_0_0_1.user(JSON, JSON) -- update(criteria, app-body)
-- one_version_0_0_1.users(JSON) -- select(criteria)
-- one_version_0_0_1.users(JSON) -- delete(critera)

-------------------
-- Query
------------------
BEGIN;

  SELECT plan(9);

/*
  SELECT results_eq(
      'SELECT current_user::TEXT username',
      'SELECT ''postgres''::TEXT username',
      'current user is postgres'
  );
  */
  SELECT has_table('one_base', 'one', 'has table');

  SELECT hasnt_pk('one_base', 'one', 'has no primary key');

  SELECT has_function(
      'one_version_0_0_1',
      'query',
      ARRAY[ 'JSON' ],
      'Function query (json) should exist'
  );
  -- TEST: Test event_logger Insert

  SELECT is (
    one_version_0_0_1.query('{"pk":"*"}'::JSON),
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'query missing json atts 0_0_1'::TEXT
  );

  SELECT ok (
    one_version_0_0_1.query('{"pk":"username#existing@user.com", "sk":"const#USER"}'::JSON) ? 'pk',
    'query pk sk good 0_0_1'::TEXT
  );

  SELECT ok (
    one_version_0_0_1.query('{"pk":"username#existing@user.com", "sk":"*"}'::JSON)::JSONB ? 'pk',
    'query pk sk:* good 0_0_1'::TEXT
  );

  SELECT ok (
    one_version_0_0_1.query('{"sk":"const#TEST", "tk": "guid#xyz420a5bd9-e669-41d4-b917-81212bc184a3"}'::JSON)::JSONB ? 'pk',
    'query sk tk good 0_0_1'::TEXT
  );

  SELECT ok (
    one_version_0_0_1.query('{"sk":"const#TEST", "tk": "*"}'::JSON)::JSONB ? 'pk',
    'query sk "tk":* good 0_0_1'::TEXT
  );

  SELECT ok (
    one_version_0_0_1.query('{"xk":"woden", "yk": "woden@citizenlabs.org"}'::JSON)::JSONB ? 'pk',
    'query xk yk good 0_0_1'::TEXT
  );
  -- {pk:"username#delete@user.com",sk:"const#USER"}
  -- {pk:"usename#nonexisting@user.com",sk:"const#USER"}
  -- Delete returns the deleted item
  -- Delete only acceptes Primary Key combination i.e., pk and sk
  SELECT is (
    one_version_0_0_1.delete('{"sk":"const#USER","tk":"guid#720a5bd9-e669-41d4-b917-81212bc184a3"}'::JSON) ->> 'status','400'::text,
    'delete sk tk bad only pk sk 0_0_1'::TEXT
  );

  SELECT is (
    one_version_0_0_1.delete('{"xk":"guid#720a5bd9-e669-41d4-b917-81212bc184a3","yk":"const#USER"}'::JSON) ->> 'status', '400'::text,
    'delete xk yk bad only pk sk 0_0_1'::TEXT
  );

  SELECT is (
    one_version_0_0_1.delete('{"pk":"username#unknown@user.com","sk":"const#USER"}'::JSON)::JSONB ->> 'count', '0'::text,
    'delete pk sk unknown 0_0_1'::TEXT
  );

  SELECT is (
    one_version_0_0_1.delete('{"pk":"username#delete@user.com","sk":"const#USER"}'::JSON)::JSONB ->> 'count', '1'::text,
    'delete pk sk good 0_0_1'::TEXT
  );
  -- Updates



  -- Insert
  SELECT is (
    one_version_0_0_1.insert('{
      "badpk":"username#insert@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'pk', ''::text,
    'insert badpk sk tk form bad  0_0_1'::TEXT
  );

  /*
  SELECT is (
    one_version_0_0_1.insert('{
      "pk":"username#insert@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSON)::JSONB ->> 'pk', ''::text,
    'insert pk sk tk form good  0_0_1'::TEXT
  );
  */
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
    one_version_0_0_1.adopter('{
      "name":  "me@someplace.com",
      "displayname", "J",
      "password": "a1A!aaaa"
      }'::JSON
    )::JSONB ->> 'status' = '200','adopter - new adopter 0_0_1'
  );

  -- duplicate adopter
-- PREPARE duplicate_adopter AS one_version_0_0_1.adopter('{"name":  "me@someplace.com", "password": "a1A!aaaa"}'::JSON);
PREPARE new_adopter as select one_version_0_0_1.adopter('{"name":  "me@someplace.com", "password": "a1A!aaaa"}'::JSON);

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
  -- Add an adopter to test the signin
  SELECT is (
    one_version_0_0_1.adopter('{
      "name":  "me@someplace.com",
      "password": "a1A!aaaa"
      }'::JSON
    ),
    '{"msg": "OK", "status": 200}'::JSONB,
    'adopter - insert 200 0_0_1'::TEXT
  );

-- TEST: Test(b) signin Insert

--| signin sucess | <guest> | 'event#<guid>' | 'signin' | <signin-form> |

SELECT ok (
  one_version_0_0_1.signin('{
    "name":  "me@someplace.com",
    "password": "a1A!aaaa"
    }'
  )::JSONB ? 'token','signin - 200 insert 0_0_1'
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
  one_version_0_0_1.adoptee( '{
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
PREPARE new_adoptee AS select one_version_0_0_1.adoptee( '{
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
  one_version_0_0_1.adoptee( '{
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
  one_version_0_0_1.adoptee( '{
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
