\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
                       _                     _
                      (_)                   | |
 _   _ ___  ___ _ __   _ _ __  ___  ___ _ __| |_
| | | / __|/ _ \ '__| | | '_ \/ __|/ _ \ '__| __|
| |_| \__ \  __/ |    | | | | \__ \  __/ |  | |_
 \__,_|___/\___|_|    |_|_| |_|___/\___|_|   \__|



*/
BEGIN;

  SELECT plan(7);
  \set guest_token public.sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"signup@user.com", "scope":"api_user"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  \set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"signup@user.com", "scope":"api_admin"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  -- insert
  -- var1 = [NULL, '',   guest_token, user_token]
  -- var2 = [NULL, NULL, NULL,        NULL]
  -- out  = [403, 403, 200, 403]
  -- 1 INSERT
  SELECT has_function(
      'api_0_0_1',
      'signup',
      ARRAY[ 'TEXT', 'JSON', 'TEXT' ],
      'Function Signup Insert (text, jsonb, text) exists'
  );
  -- 2
  SELECT is (
    api_0_0_1.signup(
      NULL::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'Signup Insert (NULL,NULL) 403 0_0_1'::TEXT
  );

-- 3
SELECT is (
  api_0_0_1.signup(
  :guest_token,
    NULL::JSON
  )::JSONB ->> 'status' = '400',
  true::Boolean,
  'Signup Insert (guest_token,NULL) 400 0_0_1'::TEXT
);
  -- 4
  SELECT is (
    api_0_0_1.signup(
    :guest_token,
      NULL::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'Signup Insert (guest_token,NULL) 400 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    api_0_0_1.signup(
    :guest_token,
    '{}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'Signup Insert (guest_token,NULL) 400 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    (api_0_0_1.signup(
      :guest_token,
      '{"username":"signup@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB - 'insertion'),
    '{"msg":"OK","status":"200"}'::JSONB,
    'Signup Insert OK 200 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    (api_0_0_1.signup(
      :guest_token,
      '{"username":"signup@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ),
    '{"msg":"Duplicate","status":"409"}'::JSONB,
    'Signup Insert duplicate 409 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    api_0_0_1.signup(
      :guest_token,
      '{"displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB,
    '{"msg":"Bad Request","status":"400"}'::JSONB,
    'Signup Insert (guest_token,{no username, displayname, password}) 400 0_0_1'::TEXT
  );
  -- 9
  SELECT is (
    api_0_0_1.signup(
      :guest_token,
      '{"username":"signup@user.com","displayname":"J"}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'Signup Insert (guest_token,{username,displayname}) 400 0_0_1'::TEXT
  );
  -- 10
  SELECT is (
    (api_0_0_1.signup(
      :guest_token,
      '{"username":"signup2@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB - 'insertion'),
    '{"msg":"OK","status":"200"}'::JSONB,
    'Signup Insert (guest_token,{username,displayname,password}) 200 0_0_1'::TEXT
  );
  -- 11
  SELECT is (
    (api_0_0_1.signup(
      :guest_token,
      '{"username":"signup3@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON,
      'duckduckgoose'
    )::JSONB - 'insertion'),
    '{"msg":"OK","status":"200"}'::JSONB,
    'Signup Insert (guest_token,{username,displayname,password},duckduckgoose) 200 0_0_1'::TEXT
  );
  -- 12
  SELECT is (
    api_0_0_1.signup(
      :user_token,
      '{"username":"signup1@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '401',
    true::Boolean,
    'Signup Insert (user_token,{username,displayname,password}) 401 0_0_1'::TEXT
  );

  -- 13
  SELECT is (
    api_0_0_1.signup(
      :admin_token,
      '{"username":"signup1@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '401',
    true::Boolean,
    'Signup Insert (admin_token,{username,displayname,password}) 401 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
