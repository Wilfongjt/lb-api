\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
Delete


*/
-------------------
-- User_ins
------------------
--\set user_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"existing@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT
--\set guest_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"guest", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT
--api_0_0_1.user(api_token TEXT, pk TEXT, sk TEXT)
BEGIN;

  SELECT plan(14);
  \set guest_token sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"existing@user.com", "scope":"api_user"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  --\set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"existing@user.com", "scope":"api_admin"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  -- 1 Delete
  SELECT has_function(
      'api_0_0_1',
      'user',
      ARRAY[ 'TEXT', 'TEXT'],
      'Function User Delete (text, text) exists'
  );

--2  Delete
  SELECT is (
    api_0_0_1.user(
      NULL::TEXT,
      NULL::TEXT
    )::JSONB ->> 'status' = '403',
    true::Boolean,
    'User Delete  FAIL 403 (NULL,NULL) 0_0_1'::TEXT
  );

  --3  Delete
    SELECT is (
      api_0_0_1.user(
        :guest_token,
        NULL::TEXT
      )::JSONB ->> 'status' = '401',
      true::Boolean,
      'User Delete(guest_token, NULL) 401  0_0_1'::TEXT
    );

    --4  Delete
    SELECT is (
      api_0_0_1.user(
        :user_token,
        NULL::TEXT
      )::JSONB ->> 'status' = '400',
      true::Boolean,
      'User Delete  Fail 400 Bad Value (user-token,NULL) 400 0_0_1'::TEXT
    );

    --5  Delete
    SELECT is (
      api_0_0_1.user(
        :user_token,
        ''::TEXT
      )::JSONB ->> 'status' = '404',
      true::Boolean,
      'User Delete  Fail pk is '' (user-token,"") 404 0_0_1'::TEXT
    );

    --6  Delete
    SELECT is (
      api_0_0_1.user(
        sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"delete1@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
        'delete1@user.com'::TEXT
      )::JSONB ->> 'status' = '200',
      true::Boolean,
      'User Delete  (user-token,"delete1@user.com") 200 0_0_1'::TEXT
    );
    -- 7  Delete Double Dip
    SELECT is (
      api_0_0_1.user(
        sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"delete1@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
        'delete1@user.com'::TEXT
      )::JSONB ->> 'status' = '404',
      true::Boolean,
      'User Delete  (user-token,"username#delete1@user.com") 404 0_0_1'::TEXT
    );
    -- 8  Delete by GUID
    SELECT is (
      api_0_0_1.user(
        sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"delete2@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
        'guid#2720a5bd9-e669-41d4-b917-81212bc184a3'::TEXT
      )::JSONB ->> 'status' = '404',
      true::Boolean,
      'User Delete  (user-token,"guid#2720a5bd9-e669-41d4-b917-81212bc184a3") 404 0_0_1'::TEXT
    );
  SELECT * FROM finish();

ROLLBACK;
