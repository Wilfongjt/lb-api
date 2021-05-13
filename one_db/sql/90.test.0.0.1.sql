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
/*
\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;
*/


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





-- user_ins
-- user_upd
-- user_sel
-- user_del

/*
 _    _                  _
| |  | |                (_)
| |  | |___  ___ _ __    _ _ __  ___
| |  | / __|/ _ \ '__|  | | '_ \/ __|
| |__| \__ \  __/ |     | | | | \__ \
 \____/|___/\___|_|     |_|_| |_|___/

*/
-------------------
-- User_ins
------------------
/*
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
    'user_ins (NULL,NULL) 403 0_0_1'::TEXT
  );
  -- 3

  SELECT is (
    api_0_0_1.user_ins(
      'xxx'::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_ins (bad_token,NULL) 403 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins (token,NULL) 400 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins (token,{}) missing chelate 400 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":""}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins (token,{pk:""}) bad primary key 400 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"","sk":""}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk:"",sk:""}) empty primary key 400 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#goodinsert@user.com","sk":"const#USER","form":{}}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk,sk, form:{}}) empty form 400 0_0_1'::TEXT
  );
  -- 9
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#goodinsert@user.com","sk":"const#USER","form":{"username":"goodinsert@user.com"}}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk,sk, form:{username}}) Missing Displayname 400 0_0_1'::TEXT
  );
  -- 10 Missing Password
  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#goodinsert@user.com","sk":"const#USER","form":{"username":"goodinsert@user.com","displayname":"string3"}}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'user_ins(token,{pk,sk, form:{username,displayname}}) MISSING Password 400 0_0_1'::TEXT
  );
  -- 11

  SELECT is (
    api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#goodinsert@user.com","sk":"const#USER","form":{"username":"goodinsert@user.com","displayname":"string3","password":"a1A!aaaa"}}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'user_ins (token,{pk, sk, form:{username, displayname, password}}) Well Formed 200 0_0_1'::TEXT
  );
  -- 12

  SELECT is (
    (api_0_0_1.user_ins(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      '{"pk":"username#insertA@user.com","sk":"const#USER","tk":"xxx","form":{"username":"insertA@user.com","displayname":"string3","password":"a1A!aaaa"}}'::JSON
    )::JSONB ->> 'insertion')::JSONB ->> 'tk'= 'xxx',
    true::Boolean,
    'user_ins (token,{pk, sk, tk:"xxx",form:{username, displayname, password}}) Overide TK 200 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
*/
/*
 _    _                  _
| |  | |                (_)
| |  | |___  ___ _ __    _ _ __  ___
| |  | / __|/ _ \ '__|  | | '_ \/ __|
| |__| \__ \  __/ |     | | | | \__ \
 \____/|___/\___|_|     |_|_| |_|___/

*/
-------------------
-- User_ins
------------------
/*
BEGIN;

  SELECT plan(7);
  -- 1
  SELECT has_function(
      'api_0_0_1',
      'user_upd',
      ARRAY[ 'TEXT', 'JSON' ],
      'Function user_upd (text, json) should exist'
  );
  -- 2
  SELECT is (
    api_0_0_1.user_upd(
      NULL::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_upd(NULL,NULL) 403 0_0_1'::TEXT
  );
  -- 3

  SELECT is (
    api_0_0_1.user_upd(
      'xxx'::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_upd(bad_token,NULL) 403 0_0_1'::TEXT
  );


  -- 4
  SELECT is (
    api_0_0_1.user_upd(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON,
        current_setting('app.settings.jwt_secret')
      )::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'user_upd(guest_token,NULL) 403 0_0_1'::TEXT
  );


  -- 5 No change

  SELECT is (
    api_0_0_1.user_upd(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"test@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{
      "pk":"username#update@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
          "username":"update@user.com",
          "displayname":"J"
        }
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'Update No change OK  0_0_1'::TEXT
  );


  -- 6 Form change OK
 SELECT is (
   (((api_0_0_1.user_upd(
       sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"test@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
       '{
         "pk":"username#update@user.com",
         "sk":"const#USER",
         "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
         "form":{
                 "username":"update@user.com",
                 "displayname":"K"
               }
        }'::JSON
     )::JSONB ->> 'updation')::JSONB ->> 'form')::JSONB ->> 'displayname'),
     'K'::TEXT,
     'Update displayname change from J to K  0_0_1'::TEXT
 );
 -- 7  password change

 SELECT is (
   api_0_0_1.user_upd(
     sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"test@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "password":"b1B!bbbb"
             }
      }'::JSON
    )::JSONB ->> 'msg',
     'OK'::TEXT,
     'Update password change OK  0_0_1'::TEXT
 );
 -- 8 this is a workaround using signin to verifiy password change
 SELECT is (
   api_0_0_1.signin(
     public.sign(
       current_setting('app.postgres_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
     '{"username":"update@user.com","password":"b1B!bbbb"}'::JSON
   )::JSONB ->> 'status',
   '200'::TEXT,
   'signin with new password 0_0_1'::TEXT
 );



 -- 9  Single Key Change only
 SELECT is (
   (api_0_0_1.user_upd(
     sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"test@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "username":"CHANGEupdate@user.com",
               "displayname":"J"
             }
      }'::JSON
    )::JSONB ->> 'updation')::JSONB ->> 'pk',
     'username#CHANGEupdate@user.com'::TEXT,
     'User_upd(TEXT, JSON) pk key change OK  0_0_1'::TEXT
 );


  SELECT * FROM finish();

ROLLBACK;
*/



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
