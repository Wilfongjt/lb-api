\c one_db


--------------
-- Environment
--------------


--\set lb _env `echo "'$LB _ENV'"`
--\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
--\set lb _guest_password `echo "'$LB _GUEST_PASSWORD'"`
--\set postgres_jwt_claims `echo "'$postgres_jwt_claims'"`
--\set api_scope     `echo "'$API_SCOPE'"`

--select :api_scope as api_scope;

---------------
-- SCHEMA: Create Schema
---------------
--CREATE SCHEMA if not exists api_0_0_1;


--------------
-- DATABASE: Alter app.settings
--------------
--ALTER DATABASE one_db SET "app.settings.jwt_secret" TO :postgres_jwt_secret;

-- doenst work ALTER DATABASE one_db SET "custom.authenticator_secret" TO 'mysecretpassword';
--------------
-- SETTINGS
--------------
-- settings are only available at runtime
-- settings are not avalable for use in this script

--ALTER DATABASE one_db SET "app.lb _env" To :lb _env;

--ALTER DATABASE one_db SET "app.lb_woden" To :lb_woden;

--ALTER DATABASE one_db SET "app.lb_guest_one" To '{"role":"guest_one"}';

--ALTER DATABASE one_db SET "app.lb_editor_one" To '{"role":"editor_one", "key":"afoekey012345"}';

--ALTER DATABASE one_db SET "app.postgres_jwt_claims" To :postgres_jwt_claims;

---------------
-- GRANT: Grant Schema Permissions
---------------


--g rant usage on schema api_0_0_1 to api_guest;
--gr ant usage on schema api_0_0_1 to api_user;

--gra nt usage on schema api_0_0_1 to api_authenticator;

---------------
-- SCHEMA: Set Schema Path
---------------

SET search_path TO api_0_0_1, base_0_0_1, public;


------------
-- FUNCTION: Create api_0_0_1.signin(token, form JSON)
------------

--   _____ _             _____          _____   ____   _____ _______
--  / ____(_)           |_   _|        |  __ \ / __ \ / ____|__   __|
-- | (___  _  __ _ _ __   | |  _ __    | |__) | |  | | (___    | |
--  \___ \| |/ _` | '_ \  | | | '_ \   |  ___/| |  | |\___ \   | |
--  ____) | | (_| | | | |_| |_| | | |  | |    | |__| |____) |  | |
-- |_____/|_|\__, |_| |_|_____|_| |_|  |_|     \____/|_____/   |_|
--          __/ |
--         |___/
/*
connect (api_authenticator)
          |
          + --->  [signin(TEXT,JSON)]
                      |
switch              (api_guest)
                      |
step                [is_valid_token(guest_token, 'api_guest')]
                      |
step                [authenticate]
                      |
step                [tokenize credentials]
                      |
switch              (api_authenticator)
                      |
return              {user_token}


connection
role
-----------
SIGNIN
(api_authenticator) --> [signin(guest_token TEXT, credentials JSON)] --> (api_guest) --> {user_token}
                                    |                 |
                          token ----+                 |
                                                      |
                          credentials                 |
                            {username:"",             |
                             password:""}-------------+
*/

CREATE OR REPLACE FUNCTION api_0_0_1.signin(guest_token TEXT,credentials JSON) RETURNS JSONB
  AS $$
    Declare _credentials JSONB; -- {"username":"","password"}
    Declare _user_token TEXT;
  BEGIN
    -- [Function: Signin given token and credentials]
    -- [Description: Get a user token given the users credentials]
    -- expect user to be connected as api_authenticator
    -- [Parameter: Credentials is {"username":"user@user.com","password":"<password>"} ]
    set role api_guest;
    -- [Validate Token]
    if not(base_0_0_1.is_valid_token(guest_token, 'api_guest') ) then
    -- [Fail 403 when token is invalid]
      RESET ROLE;
      return '{"status":"403","msg":"Forbidden","extra":"invalid token"}'::JSONB;
    end if;
    -- [Switch Role]
    set role api_guest; -- api_authenticator allows this switch but doesnt dictate it
    -- [Validate Credentials]
    _credentials := base_0_0_1.validate_credentials(credentials::JSONB);
    if _credentials is NULL then
      -- [Fail 400 when credentials are NULL or missing]
      RESET ROLE;
      return '{"status":"400","msg":"Bad Request"}'::JSONB;
    end if;

    --_credentials := _credentials || '{"scope":"api_user"}';

    _user_token := NULL;

    BEGIN
      -- [Verify User Credentials]
      -- [Generate user token]

          SELECT public.sign(row_to_json(r), current_setting('app.settings.jwt_secret')) AS token into _user_token
               FROM (
                 SELECT
                   current_setting('app.postgres_jwt_claims')::JSONB ->> 'aud' as aud,
                   current_setting('app.postgres_jwt_claims')::JSONB ->> 'iss' as iss,
                   current_setting('app.postgres_jwt_claims')::JSONB ->> 'sub' as sub,
                   form ->> 'username' as user,
                   form ->> 'scope' as scope,
                   pk as jti,
                   tk as key
                 from base_0_0_1.one
                 where
               			LOWER(pk) = LOWER(format('username#%s', _credentials ->> 'username'))
               			and sk = 'const#USER'
               			and form ->> 'password' = crypt(_credentials ->> 'password', form ->> 'password')
               ) r;

      -- evaluate results
      if _user_token is NULL then
        -- [Fail 404 when User Credentials are not found]
        RESET ROLE;
        _credentials := _credentials || '{"password":"********"}'::JSONB;
        return format('{"status":"404","msg":"Not Found","credentials":%s}',_credentials)::JSONB;
      end if;
    EXCEPTION
            when others then
              RESET ROLE;
              RAISE NOTICE 'Insert Beyond here there be dragons! %', sqlstate;
              return format('{"status":"%s", "msg":"Unhandled"}', sqlstate)::JSONB;
    END;
    RESET ROLE;
    -- calculate the token
    -- [Return {status,msg,token}]
    return format('{"status":"200","msg":"OK","token":"%s"}',_user_token)::JSONB;

  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute

grant EXECUTE on FUNCTION api_0_0_1.signin(TEXT, JSON) to api_authenticator;
