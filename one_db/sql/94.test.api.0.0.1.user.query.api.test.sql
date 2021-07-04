\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
                                _           _
                               | |         | |
 _   _ ___  ___ _ __   ___  ___| | ___  ___| |_
| | | / __|/ _ \ '__| / __|/ _ \ |/ _ \/ __| __|
| |_| \__ \  __/ |    \__ \  __/ |  __/ (__| |_
 \__,_|___/\___|_|    |___/\___|_|\___|\___|\__|

*/
-------------------
-- User_ins
------------------
--\set user_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"existing@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT
--\set guest_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"guest", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT

BEGIN;
   -- [Insert test users]
  insert into base_0_0_1.one (pk,sk,form,owner) values ('username#query@user.com',  'const#USER', '{"username":"query@user.com", "sk":"const#USER"}'::JSONB, 'queryUserKey' );
  insert into base_0_0_1.one (pk,sk,form,owner) values ('username#query1@user.com', 'const#USER', '{"username":"query1@user.com","sk":"const#USER"}'::JSONB, 'query1UserKey' );
  insert into base_0_0_1.one (pk,sk,form,owner) values ('username#query2@user.com', 'const#USER', '{"username":"query2@user.com","sk":"const#USER"}'::JSONB, 'query2UserKey' );

  SELECT plan(14);
  \set guest_token sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"query@user.com", "scope":"api_user","key":"queryUserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  \set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"query@user.com", "scope":"api_admin","key":"queryUserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT


  -- function
  -- query user(NULL NULL NULL)
  -- 1 query
  SELECT has_function(
      'api_0_0_1',
      'user',
      ARRAY[ 'TEXT', 'JSON', 'JSON' ],
      'Function User Query (text, json, json) exists'
  );
--2  query
  SELECT is (
    api_0_0_1.user(
      NULL::TEXT,
      NULL::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'User Query  (NULL,NULL),{} 403 0_0_1'::TEXT
  );
  -- 3  query
  SELECT is (
    api_0_0_1.user(
      ''::TEXT,
      NULL::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'User Query  ("",NULL) 403 0_0_1'::TEXT
  );
  -- 4   query
  SELECT is (
    api_0_0_1.user(
    'xxx'::TEXT,
      NULL::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'User Query  (xxx),NULL) 403 0_0_1'::TEXT
  );
  -- 5  query
  SELECT is ( -- conn as guest, switch to guest and try query
    api_0_0_1.user(
      :guest_token,
      NULL::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '401',
    true::Boolean,
    'User Query  (guest_token,NULL) 401 0_0_1'::TEXT
  );
  -- 6  query
  SELECT is (
    api_0_0_1.user(
      :user_token,
      NULL::JSON,
      '{}'::JSON
    )::JSONB,
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'User Query  (user_token,NULL) Token query 400 0_0_1'::TEXT
  );

  -- 7  query
  SELECT is (
    api_0_0_1.user(
      :user_token,
      '{}'::JSON,
      '{}'::JSON
    )::JSONB,
    '{"msg": "Bad Request", "status": "400"}'::JSONB,
    'User Query  (user_token,{}) 400 0_0_1'::TEXT
  );

  -- 8  query
  SELECT is (
    api_0_0_1.user(
      :user_token,
      '{"pk":""}'::JSON,
      '{}'::JSON
    )::JSONB ,
    '{"msg": "Not Found", "status": "404", "criteria": {"pk": "", "sk": "*"}}'::JSONB,
    'User Query  (user_token,{username:""}) 400 0_0_1'::TEXT
  );

  -- 9  query
  SELECT is (
    (api_0_0_1.user(
      :user_token,
      '{"pk":"username#query@user.com","sk":"const#USER"}'::JSON,
      '{}'::JSON
    )::JSONB - 'selection'),
    '{"msg": "OK", "status": "200"}'::JSONB,
    'User Query  (user_token,{username:good}) 200 0_0_1'::TEXT
  );

  -- 10  query
  SELECT is (
    (api_0_0_1.user(
      :user_token,
      '{"pk":"username#query@user.com","sk":"*"}'::JSON,
      '{}'::JSON
    )::JSONB - 'selection'),
    '{"msg": "OK", "status": "200"}'::JSONB,
    'User Query  (user_token,{username:good}) 200 0_0_1'::TEXT
  );

  /*
  -- 11  query
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"pk":"username#existing@user.com"}'::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'User Query  (admin_token,{username:good}) 200 0_0_1'::TEXT
  );
  -- 12  query
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"pk":"username#existing@user.com","sk":"const#USER"}'::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'User Query  (admin_token,{username:good}) 200 0_0_1'::TEXT
  );

  -- 11  query
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"pk":"username#existing@user.com"}'::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'User Query  (admin_token,{username:good}) 400 0_0_1'::TEXT
  );

  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"username":""}'::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '404',
    true::Boolean,
    'User Query  (admin_token,{username:""}) 404 0_0_1'::TEXT
  );
  -- 12  query
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"username":"bad"}'::JSON,
      '{}'::JSON
    )::JSONB ->> 'status' = '404',
    true::Boolean,
    'User Query  (admin_token,{username:""}) 404 0_0_1'::TEXT
  );

  --  query
 -- 13  Single Key Change only
 SELECT is (
   to_jsonb(api_0_0_1.user(
     :admin_token,
     '{"username":"existing@user.com"}'::JSON,
     '{}'::JSON
     )::JSON#>'{selection,0}'
   ) ->> 'pk',
   'username#existing@user.com'::TEXT,
   'User Query (admin_token,{username}) OK  0_0_1'::TEXT
 );


-- 14  Single Key Change only
SELECT is (
  to_jsonb(api_0_0_1.user(
    :admin_token,
    '{"guid":"520a5bd9-e669-41d4-b917-81212bc184a3"}'::JSON,
    '{}'::JSON
    )::JSON#>'{selection,0}'
  ) ->> 'pk',
  'username#existing@user.com'::TEXT,
  'User Query (admin_token,{guid}) OK  0_0_1'::TEXT
);
*/
  SELECT * FROM finish();

ROLLBACK;
-- END;
