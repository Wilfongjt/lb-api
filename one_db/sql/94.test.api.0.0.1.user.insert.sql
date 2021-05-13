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
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"existing@user.com", "scope":"api_user"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  \set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"existing@user.com", "scope":"api_admin"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  -- insert
  -- var1 = [NULL, '',   guest_token, user_token]
  -- var2 = [NULL, NULL, NULL,        NULL]
  -- out  = [403, 403, 200, 403]
  -- 1 INSERT
  SELECT has_function(
      'api_0_0_1',
      'user',
      ARRAY[ 'TEXT', 'JSON' ],
      'Function User Insert (text, jsonb) exists'
  );
  -- 2
  SELECT is (
    api_0_0_1.user(
      NULL::TEXT,
      NULL::JSON
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'User Insert (NULL,NULL) 403 0_0_1'::TEXT
  );


-- 3
SELECT is (
  api_0_0_1.user(
  :guest_token,
    NULL::JSON
  )::JSONB ->> 'status' = '400',
  true::Boolean,
  'User Insert (guest_token,NULL) 400 0_0_1'::TEXT
);
  -- 4
  SELECT is (
    api_0_0_1.user(
    :guest_token,
      NULL::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'User Insert (guest_token,NULL) 400 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    api_0_0_1.user(
    :guest_token,
    '{}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'User Insert (guest_token,NULL) 400 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    api_0_0_1.user(
      :guest_token,
      '{"username":"existing@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '409',
    true::Boolean,
    'User Insert duplicate 409 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    api_0_0_1.user(
      :guest_token,
      '{"displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'User Insert (guest_token,{no username, displayname, password}) 400 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    api_0_0_1.user(
      :guest_token,
      '{"username":"test@user.com","displayname":"J"}'::JSON
    )::JSONB ->> 'status' = '400',
    true::Boolean,
    'User Insert (guest_token,{username,displayname}) 400 0_0_1'::TEXT
  );
  -- 9
  SELECT is (
    api_0_0_1.user(
      :guest_token,
      '{"username":"test@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'User Insert (guest_token,{username,displayname,password}) 200 0_0_1'::TEXT
  );
  -- 10
  SELECT is (
    api_0_0_1.user(
      :user_token,
      '{"username":"test1@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '401',
    true::Boolean,
    'User Insert (user_token,{username,displayname,password}) 401 0_0_1'::TEXT
  );
  -- 11
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"username":"test1@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '401',
    true::Boolean,
    'User Insert (admin_token,{username,displayname,password}) 401 0_0_1'::TEXT
  );
  -- 12
  SELECT is (
    api_0_0_1.user(
      :guest_token,
      '{"username":"new@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status' = '200',
    true::Boolean,
    'User Insert (guest_token,{username,displayname,password}) 200 0_0_1'::TEXT
  );
  -- signin
  SELECT * FROM finish();

ROLLBACK;
