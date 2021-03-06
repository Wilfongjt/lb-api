\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
 _             _
(_)           (_)
 ___ _  __ _ _ __  _ _ __
/ __| |/ _` | '_ \| | '_ \
\__ \ | (_| | | | | | | | |
|___/_|\__, |_| |_|_|_| |_|
        __/ |
       |___/

*/

BEGIN;
--insert into base_0_0_1.one (pk,sk,form,owner) values ('username#signin@user.com', 'const#USER', '{"username":"signin@user.com","sk":"const#USER"}'::JSONB, 'signinOwner' );
  \set guest_token public.sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT

  select api_0_0_1.signup(
    :guest_token,
    '{"username":"signin@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
  );

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
      '{"username":"signin@user.com",
        "password":"a1A!aaaa"
       }'::JSON)::JSONB ->> 'msg',
    'Forbidden'::TEXT,
    'signin NO token, GOOD credentials,  Forbidden 0_0_1'::TEXT
  );
  -- 5
  --sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"guest", "key":"0", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
  SELECT is (
    api_0_0_1.signin(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"guest", "key":"0", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"unknown@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'msg',
    'Not Found'::TEXT,
    'signin GOOD token Bad Username Credentials 0_0_1'::TEXT
  );

  -- 6
  SELECT is (
    api_0_0_1.signin(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"signin@user.com","password":"unknown"}'::JSON
    )::JSONB ->> 'msg',
    'Not Found'::TEXT,
    'signin GOOD token BAD Password Credentials 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    (api_0_0_1.signin(
      :guest_token,
      '{"username":"signin@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB || '{"token":"********"}'),
    '{"msg": "OK", "token": "********", "status": "200"}'::JSONB,
    'signin GOOD token GOOD Credentials 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    (api_0_0_1.signin(
      public.sign(
        current_setting('app.postgres_jwt_claims')::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      '{"username":"signin@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB || '{"token":"********"}'),
    '{"msg": "OK", "token": "********", "status": "200"}'::JSONB,
    'signin GOOD token GOOD Credentials Returns TOKEN 0_0_1'::TEXT
  );

  -- 9

  -- TOKEN TESTS

  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;
-- END;
