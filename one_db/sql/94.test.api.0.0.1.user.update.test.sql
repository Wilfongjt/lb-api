\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*
Update User  token, <username>|<guid>, {username:<value>, displayname:<value>, password:<value>}
Update User  token, <username>|<guid>, {username:<value>}
Update User  token, <username>|<guid>, {                  displayname:<value>}
Update User  token, <username>|<guid>, {                                       password:<value>}
Update User  token, <username>|<guid>, {username:<value>, displayname:<value>}
Update User  token, <username>|<guid>, {                  displayname:<value>, password:<value>}
Update User  token, <username>|<guid>, {username:<value>,                      password:<value>}

*/


BEGIN;

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      'updateUserKey'
  );

\set guest_token sign(current_setting('''app.postgres_jwt_claims''')::JSON,current_setting('''app.settings.jwt_secret'''))::TEXT
\set user_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"update@user.com", "scope":"api_user","key":"updateUserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT
\set admin_token sign((current_setting('''app.postgres_jwt_claims''')::JSONB || '''{"user":"update@user.com", "scope":"api_admin","key":"updateUserKey"}'''::JSONB)::JSON, current_setting('''app.settings.jwt_secret'''))::TEXT

-- insert used only for testing
/*
insert into base_0_0_1.one
  (pk, sk, tk, form, active, created, updated, owner)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'true'::BOOLEAN,
      '2021-02-21 20:44:47.442374',
      '2021-02-21 20:44:47.442374',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3'
  );
*/
  SELECT plan(5);
  -- 1 query
  SELECT has_function(
      'api_0_0_1',
      'user',
      ARRAY[ 'TEXT', 'TEXT', 'JSON' ],
      'Function User Update (text, text, json) exists'
  );
  -- 2
  SELECT is (
    api_0_0_1.signin(
      :guest_token,
      '{"username":"update@user.com","password":"a1A!aaaa"}'::JSON
    )::JSONB ? 'token',
    true::Boolean,
    'User signin Good token, Good Credentials Returns TOKEN 0_0_1'::TEXT
  );
  --  3 Update without Key Change

  SELECT is (
    (api_0_0_1.user(
      :user_token,
      'username#update@user.com'::TEXT,

      '{"username":"update@user.com",
                "displayname":"LLL",
                "password":"a1A!aaaa"
      }'::JSON)::JSONB - 'updation'),

      '{"msg":"OK","status":"200"}'::JSONB,

      'User Update OK non key change 0_0_1'::TEXT
  );
/*
  --  4 Update without Key Change

  SELECT is (
    (api_0_0_1.user(
      :user_token,
      'username#update@user.com'::TEXT,
      '{
        "displayname":"AAA"
      }'::JSON)::JSONB  - 'updation'),
      '{"msg":"OK","status":"200"}'::JSONB,
      'User Update OK displayname solo change 0_0_1'::TEXT
  );

  -- 5 password

  SELECT is (
    (api_0_0_1.user(
      :user_token,
      'username#update@user.com'::TEXT,
      '{
                 "password":"b1B!bbbb"
      }'::JSON)::JSONB  - 'updation'),
      '{"msg":"OK","status":"200"}'::JSONB,
      'User Update OK password solo change 0_0_1'::TEXT
  );

  -- 6
  SELECT is (
    (api_0_0_1.signin(
      :guest_token,
      '{"username":"update@user.com","password":"b1B!bbbb"}'::JSON
    )::JSONB  - 'updation'),
    '{"msg":"OK","status":"200"}'::JSONB,
    'signin GOOD token, GOOD Credentials Returns TOKEN 0_0_1'::TEXT
  );

*/

  /*

  -- 3 password change
  SELECT is (
    api_0_0_1.user(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"update@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      'username#update@user.com'::TEXT,
      '{username":"update@user.com",
              "displayname":"LLL",
              "password":"a1A!aaaa"
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'User Update OK key change 0_0_1'::TEXT
  );
  -- 4 Update with Key Change
  SELECT is (
    api_0_0_1.user(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"update@user.com", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      'username#update@user.com'::TEXT,
      '{"username":"changeupdate@user.com",
              "displayname":"LLL",
              "password":"a1A!aaaa"
      }'::JSON)::JSONB ->> 'msg',
      'OK'::TEXT,
      'User Update OK key change 0_0_1'::TEXT
  );
*/
  SELECT * FROM finish();

ROLLBACK;
