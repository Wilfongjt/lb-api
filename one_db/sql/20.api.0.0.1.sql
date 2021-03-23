\c one_db
--------------
-- Environment
--------------


\set lb_env `echo "'$LB_ENV'"`
\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
\set lb_guest_password `echo "'$LB_GUEST_PASSWORD'"`
\set lb_jwt_claims `echo "'$LB_JWT_CLAIMS'"`
\set api_scope     `echo "'$API_SCOPE'"`

select :api_scope as api_scope;

---------------
-- SCHEMA: Create Schema
---------------
CREATE SCHEMA if not exists api_0_0_1;


--------------
-- DATABASE: Alter app.settings
--------------
ALTER DATABASE one_db SET "app.settings.jwt_secret" TO :postgres_jwt_secret;

-- doenst work ALTER DATABASE one_db SET "custom.authenticator_secret" TO 'mysecretpassword';
--------------
-- SETTINGS
--------------
-- settings are only available at runtime
-- settings are not avalable for use in this script

ALTER DATABASE one_db SET "app.lb_env" To :lb_env;

--ALTER DATABASE one_db SET "app.lb_woden" To :lb_woden;

ALTER DATABASE one_db SET "app.lb_guest_one" To '{"role":"guest_one"}';

ALTER DATABASE one_db SET "app.lb_editor_one" To '{"role":"editor_one", "key":"afoekey012345"}';

ALTER DATABASE one_db SET "app.lb_jwt_claims" To :lb_jwt_claims;

---------------
-- GRANT: Grant Schema Permissions
---------------
--g rant usage on schema base_0_0_1 to guest_one;
--g rant usage on schema base_0_0_1 to editor_one;
--g rant usage on schema base_0_0_1 to event_logger_role;

--grant usage on schema api_0_0_1 to guest_one;
--grant usage on schema api_0_0_1 to editor_one;
--grant usage on schema api_0_0_1 to event_logger_role;
--grant usage on schema api_0_0_1 to api_user_one;

grant usage on schema api_0_0_1 to api_guest;
grant usage on schema api_0_0_1 to api_user;

grant usage on schema api_0_0_1 to guest_authenticator;

---------------
-- SCHEMA: Set Schema Path
---------------

SET search_path TO api_0_0_1, base_0_0_1, public;

----------------
-- TYPE: Create Types
----------------

--=============================================================================
--=============================================================================
--=============================================================================

------------
-- FUNCTION: Create api_0_0_1.user(token TEXT,form JSON)
------------


--  _    _                 _____                     _
-- | |  | |               |_   _|                   | |
-- | |  | |___  ___ _ __    | |  _ __  ___  ___ _ __| |_
-- | |  | / __|/ _ \ '__|   | | | '_ \/ __|/ _ \ '__| __|
-- | |__| \__ \  __/ |     _| |_| | | \__ \  __/ |  | |_
--  \____/|___/\___|_|    |_____|_| |_|___/\___|_|   \__|

-- Input: guest_token TEXT,
-- Input: chelate JSON,
-- Returns: {status, msg, insertion } or {status, msg, extra}
-- PATTERNS:
--   user_ins(TEXT, JSON) Insert
--     JSON with Pattern of (guest_token, {pk,sk,tk,form}) is Insertable Chelate
--     JSON with Pattern of (guest_token, {pk,sk,   form}) is Insertable Chelate
--     JSON with Pattern of (guest_token, {   sk,tk,form}) is Insertable Chelate
--     otherwise exception

CREATE OR REPLACE FUNCTION api_0_0_1.user_ins(guest_token TEXT, chelate JSON) RETURNS JSONB
AS $$
declare userId TEXT;
declare scopeId TEXT;
declare _chelate JSONB;
declare  results JSONB;
declare result JSONB;
BEGIN
  set ROLE api_guest;
  -- evaluate token: is guest,  is not null
  if not(base_0_0_1.is_valid_token(guest_token, 'guest') ) then
    RESET ROLE;
    return '{"status":"403","msg":"Forbidden","extra":"Invalid token"}'::JSONB;
  end if;
  _chelate := chelate::JSONB;
  -- User expects, pk,sk,tk, form and user
  if chelate is NULL or _chelate = '{}'::JSONB then
    RESET ROLE;
    return '{"status":"400","msg":"Bad Request", "extra":"Chelate is NULL"}'::JSONB;
  elsif not(_chelate ? 'form') then
    RESET ROLE;
    return '{"status":"400","msg":"Bad Request", "extra":"Chelate missing form"}'::JSONB;
  elsif not(_chelate ? 'pk') and not(_chelate ->> 'pk' = '') then
    RESET ROLE;
    return '{"status":"400","msg":"Bad Request", "extra":"Chelate missing pk"}'::JSONB;
  elsif not(_chelate ? 'sk') and not(_chelate ->> 'sk' = '') then
    RESET ROLE;
    return '{"status":"400","msg":"Bad Request", "extra":"Chelate missing sk"}'::JSONB;
  elsif not(_chelate ? 'tk') or _chelate ->> 'tk' = '' then
    userId := format('guid#%s',uuid_generate_v4 ());
  end if;

  -- get user and scope from token
  --SELECT  payload::JSONB ->> 'scope' into scopeId
  --  FROM verify(guest_token, current_setting('app.settings.jwt_secret'));
  -- set session variables

  set session "app.scope" = 'guest';
  userId := COALESCE(userId, _chelate ->> 'tk');
  set session "app.user" = userId;
  -- switch role
  -- what is ROLE, how is it represented
  --set ROLE api_user_one;
  result := base_0_0_1.insert(_chelate);
  RESET ROLE;

  return result;
END;
$$ LANGUAGE plpgsql;

-- grant EXECUTE on FUNCTION api_0_0_1.user_ins(TEXT, JSON) to api_user_one;
grant EXECUTE on FUNCTION api_0_0_1.user_ins(TEXT, JSON) to api_guest;


--  _    _                 _    _           _       _
-- | |  | |               | |  | |         | |     | |
-- | |  | |___  ___ _ __  | |  | |_ __   __| | __ _| |_ ___
-- | |  | / __|/ _ \ '__| | |  | | '_ \ / _` |/ _` | __/ _ \
-- | |__| \__ \  __/ |    | |__| | |_) | (_| | (_| | ||  __/
--  \____/|___/\___|_|     \____/| .__/ \__,_|\__,_|\__\___|
--                               | |
--                               |_|
-- Input: guest_token TEXT,
-- Input: chelate JSON,
-- Returns: {status, msg, insertion } or {status, msg, extra}
--
-- knowing
-- user_upd(token TEXT, JSON, JSON) Update
--   JSON with Pattern of (TEXT, {pk, sk    },{pk,sk,tk,form}) is Updateable Chelate
--   JSON with Pattern of (TEXT, {    sk, tk},{pk,sk,tk,form}) is Updateable Chelate
--   otherwise exception


CREATE OR REPLACE FUNCTION api_0_0_1.user_upd(user_token TEXT, chelate JSON) RETURNS JSONB
  AS $$
  declare result JSONB;
  BEGIN
    set ROLE OWNER;
    -- requires token
    if user_token is NULL then
      RESET ROLE;
      return '{"status":"403","msg":"Forbidden","extra":"null token"}'::JSONB;
    end if;
    -- is guest
    if not(base_0_0_1.is_valid_token(user_token, 'api') ) then
      RESET ROLE;
      return '{"status":"403","msg":"Forbidden","extra":"invalid token"}'::JSONB;
    end if;
    -- expects a chelate
    if chelate is NULL then
      RESET ROLE;
      return '{"status":"400","msg":"Bad Request", "extra":"chelate is NULL"}'::JSONB;
    end if;

    -- need to pull out the users id from the user_token

    -- insert the chelate
    --RESET ROLE;
    result := api_0_0_1.update(chelate);
    RESET ROLE;
    return result;
  END;
  $$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION api_0_0_1.user_ins(TEXT, JSON) to api_user;


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


CREATE OR REPLACE FUNCTION api_0_0_1.signin(guest_token TEXT,credentials JSON) RETURNS JSONB
  AS $$
    Declare _credentials JSONB;
    Declare _user_token TEXT;
  BEGIN

    set role api_guest;

    if guest_token is NULL then
      RESET ROLE;
      return '{"status":"403","msg":"Forbidden","extra":"null token"}'::JSONB;
    end if;
    set role api_guest;
    if not(base_0_0_1.is_valid_token(guest_token, 'guest') ) then
      RESET ROLE;
      return '{"status":"403","msg":"Forbidden","extra":"invalid token"}'::JSONB;
    end if;
    if credentials is NULL then
      RESET ROLE;
      return '{"status":"400","msg":"Bad Request"}'::JSONB;
    end if;

    -- process here
    _credentials := credentials::JSONB;
    _user_token := NULL;

    if not(_credentials ? 'username'
            and _credentials ? 'password') then    -- validate name and password
        RESET ROLE;
        return '{"status":"400","msg":"Bad Request"}'::JSONB;
    end if;
    BEGIN
      SELECT public.sign(row_to_json(r), current_setting('app.settings.jwt_secret')) AS token into _user_token
           FROM (
             SELECT
               current_setting('app.lb_jwt_claims')::JSONB ->> 'aud' as aud,
               current_setting('app.lb_jwt_claims')::JSONB ->> 'iss' as iss,
               current_setting('app.lb_jwt_claims')::JSONB ->> 'sub' as sub,
               form ->> 'username' as user,
               form ->> 'scope' as scope,
               pk as jti,
               tk as key
             from base_0_0_1.one
             where
           			pk = LOWER(format('username#%s', _credentials ->> 'username'))
           			and sk = 'const#USER'
           			and form ->> 'password' = crypt(_credentials ->> 'password', form ->> 'password')
           ) r;

      -- evaluate results
      if _user_token is NULL then
        return '{"status":"404","msg":"Not Found"}'::JSONB;
      end if;
    EXCEPTION
            when others then
              RESET ROLE;
              RAISE NOTICE 'Insert Beyond here there be dragons! %', sqlstate;
              return format('{"status":"%s", "msg":"Unhandled"}', sqlstate)::JSONB;
    END;
    RESET ROLE;
    -- calculate the token
    return format('{"status":"200","msg":"OK","token":"%s"}',_user_token)::JSONB;

  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute

grant EXECUTE on FUNCTION api_0_0_1.signin(TEXT, JSON) to guest_authenticator;
