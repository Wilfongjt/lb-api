\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
Delete


*/
-------------------
-- User_
------------------
--\set user_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"delete@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT
--\set guest_token sign((current_setting('app.postgres_jwt_claims')::JSONB || \'{"user":"guest", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT
--api_0_0_1.user(api_token TEXT, pk TEXT, sk TEXT)
BEGIN;
insert into base_0_0_1.one (pk,sk,form,owner) values ('username#delete@user.com', 'const#USER', '{"username":"delete@user.com","sk":"const#USER"}'::JSONB, 'queryUserKey' );

  SELECT plan(14);
  \set guest_token sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT
  \set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"delete@user.com", "scope":"api_user","key":"queryUserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  \set user_token_1 sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"delete1@user.com", "scope":"api_user","key":"query1UserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
  --\set user_token_3 sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"delete2@user.com", "scope":"api_user","key":"query2"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  --\set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"delete@user.com", "scope":"api_admin","key":"queryadmin"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

  -- 1 Delete
  SELECT has_function(
      'api_0_0_1',
      'user',
      ARRAY[ 'TEXT', 'TEXT'],
      'Function User Delete (text, text) exists'
  );

--2  try to Delete with Null token and Null pk
  SELECT is (
    api_0_0_1.user(
      NULL::TEXT,
      NULL::TEXT
    )::JSONB,
    '{"msg": "Forbidden", "user": "postgres", "extra": "Invalid token", "status": "403"}'::JSONB,
    'A NULL token cant Delete a user 0_0_1'::TEXT
  );

  --3  try Delete with wrong token and null pk
    SELECT is (
      api_0_0_1.user(
        :guest_token,
        NULL::TEXT
      )::JSONB,
      '{"msg": "Unauthorized", "status": "401"}'::JSONB,
      'A guest_token cant Delete a user 0_0_1'::TEXT
    );

    --4  try to Delete with null pk
    SELECT is (
      api_0_0_1.user(
        :user_token,
        NULL::TEXT
      )::JSONB,
      '{"msg": "Bad Request", "status": "400"}'::JSONB,
      'A user_token cant Delete a user 0_0_1'::TEXT
    );

    --5  try to Delete with no pk value
    SELECT is (
      api_0_0_1.user(
        :user_token,
        ''::TEXT
      )::JSONB,
      '{"msg": "Not Found", "owner": "queryUserKey", "status": "404", "criteria": {"pk": "username#", "sk": "const#USER"}}'::JSONB,
      'A user_token cant Delete a blank user 0_0_1'::TEXT
    );
    --6  try to Delete with wrong token
    SELECT is (
      api_0_0_1.user(
        :user_token_1,
        'delete@user.com'::TEXT
      )::JSONB ,
      '{"msg": "Not Found", "owner": "query1UserKey", "status": "404", "criteria": {"pk": "username#delete@user.com", "sk": "const#USER"}}'::JSONB,
      'User Delete  (user-token,"delete@user.com") 404 0_0_1'::TEXT
    );
    --7  Delete OK
    SELECT is (
      (api_0_0_1.user(
        :user_token,
        'delete@user.com'::TEXT
      )::JSONB - '{criteria,deletion}'::text[]),
      '{"msg": "OK", "status": "200"}'::JSONB,
      'User Delete  (user-token,"delete@user.com") 200 0_0_1'::TEXT
    );
    -- 8  Delete Double Dip
    SELECT is (
      api_0_0_1.user(
        :user_token,
        'delete@user.com'::TEXT
      )::JSONB ->> 'status',
      '404',
      'User Delete  (user-token,"username#delete@user.com") 404 0_0_1'::TEXT
    );
    -- 9  Delete by GUID
/*
    SELECT is (
      api_0_0_1.user(
        :user_token_3,
        'guid#2720a5bd9-e669-41d4-b917-81212bc184a3'::TEXT
      )::JSONB ->> 'status',
      '404',
      'User Delete  (user-token,"guid#2720a5bd9-e669-41d4-b917-81212bc184a3") 404 0_0_1'::TEXT
    );
*/
  SELECT * FROM finish();

ROLLBACK;
