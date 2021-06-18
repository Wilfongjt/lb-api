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
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"inserted@user.com", "scope":"api_user"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  \set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"inserted@user.com", "scope":"api_admin"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  -- insert
  -- var1 = [NULL, '',   guest_token, user_token]
  -- var2 = [NULL, NULL, NULL,        NULL]
  -- out  = [403, 403, 200, 403]

  -- Insert record for duplicate test

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
    )::JSONB,
    '{"msg": "Forbidden", "user": "postgres", "extra": "Invalid token", "status": "403"}'::JSONB,
    'A NULL token cant be used to add a user 0_0_1'::TEXT
  );


-- 3
SELECT is (
  api_0_0_1.user(
  :guest_token,
    NULL::JSON
  )::JSONB,
  '{"msg": "Unauthorized", "status": "401"}'::JSONB,
  'A guest_token cant add a NULL user 0_0_1'::TEXT
);
  -- 4

  SELECT is (
    api_0_0_1.user(
      :user_token,
      NULL::JSON
    )::JSONB,
    '{"msg": "Unauthorized", "status": "401"}'::JSONB,
    'A user_token cant add a NULL user 0_0_1'::TEXT  );

  -- 5
  SELECT is (
    api_0_0_1.user(
      :user_token,
      '{"username":"inserted@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB,
    '{"msg": "Unauthorized", "status": "401"}'::JSONB,
    'A user_token cant add new user 0_0_1'::TEXT
  );
  -- 6
  /*
  SELECT is (
    api_0_0_1.user(
      :admin_token,
      '{"username":"inserted@user.com","displayname":"J","password":"a1A!aaaa"}'::JSON
    )::JSONB ->> 'status',
    '200',
    'An admin_token can add new user 0_0_1'::TEXT
  );
  */

  SELECT * FROM finish();

ROLLBACK;
