\c one_db
--------------
-- Environment
--------------

-- TODO ?.?.?: When adopter is deactivated then deactivate all adoptions by that adopter
-- TODO ?.?.?: test for active adopter record during signin. When active is false then adopter is the same as deleted.
-- TODO 1.4.2: All adoptees are showing up with red symbol. red is for currently logged in user
-- Done 1.4.1: adoptees empty query should return [] rather than raise exception
-- DONE 1.4.0: adoptees Should return a json array
-- DONE 1.4.0: Add boundary search to adoptee
-- DONE 1.4.0: change 1.3.0 to 1.4.0
-- DONE 1.4.0: remove commented code
-- DONE 1.2.1: Change "process" type to "event" type
-- DONE 1.2.1: Change Process_logger to event_logger
-- DONE 1.2.1: Change 1_2_1 to 1_3_0
-- DONE 1.2.1: Create add_base schema
-- DONE 1.2.1: Move adopt_a_drain table to base_0_0_1 schema
-- DONE 1.2.1: stop insert of duplicate adoptee
-- DONE 1.2.1: add tk to adopter insert
-- DONE 1.2.1: add tk to adoptee insert
-- DONE 1.2.1: add tk to signin

--\set lb _env `echo "'$LB _ENV'"`
\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
--\set lb _guest_password `echo "'$LB _GUEST_PASSWORD'"`
\set postgres_jwt_claims `echo "'$POSTGRES_JWT_CLAIMS'"`
\set dep_api_scope     `echo "'$API_SCOPE'"`
\set postgres_api_password `echo "'$POSTGRES_API_PASSWORD'"`


--select :lb _env as lb _env;
--select :lb _guest_password as lb _guest_password;
--select :postgres_jwt_secret as postgres_jwt_secret;
--select :postgres_jwt_claims as postgres_jwt_claims;
--select :dep_api_scope as api_scope;


---------------
-- SCHEMA: Create Schema
---------------
CREATE SCHEMA if not exists base_0_0_1;

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
-- SET: "app.lb _env" To :lb _env;
--ALTER DATABASE one_db SET "app.lb _env" To :lb _env;
-- SET: "app.postgres_jwt_claims" To :postgres_jwt_claims
ALTER DATABASE one_db SET "app.postgres_jwt_claims" To :postgres_jwt_claims;
ALTER DATABASE one_db SET "app.postgres_api_password" To :postgres_api_password;
-- next line will fail if POSTGRESS_API_PASSWORD is not defined
ALTER ROLE api_authenticator WITH PASSWORD :postgres_api_password;

---------------
-- GRANT: Grant Schema Permissions
---------------

--   _____      _
--  / ____|    | |
-- | (___   ___| |__   ___ _ __ ___   __ _
--  \___ \ / __| '_ \ / _ \ '_ ` _ \ / _` |
--  ____) | (__| | | |  __/ | | | | | (_| |
-- |_____/ \___|_| |_|\___|_| |_| |_|\__,_|


GRANT usage on schema base_0_0_1 to event_logger_role;
--GRANT usage on schema base_0_0_1 to api_guest;

GRANT usage on schema base_0_0_1 to event_logger_role;

GRANT usage on schema base_0_0_1 to api_guest;
GRANT usage on schema base_0_0_1 to api_user;
GRANT usage on schema base_0_0_1 to api_admin;
---------------
-- SCHEMA: Set Schema Path
---------------

SET search_path TO base_0_0_1, public;

----------------
-- TYPE: Create Types
----------------

CREATE TYPE base_0_0_1.jwt_token AS (
  token text
);
----------------
-- TABLE: Create Table
----------------
--  _______    _     _
-- |__   __|  | |   | |
--    | | __ _| |__ | | ___
--    | |/ _` | '_ \| |/ _ \
--    | | (_| | |_) | |  __/
--    |_|\__,_|_.__/|_|\___|

CREATE TABLE if not exists base_0_0_1.one  (
        pk TEXT DEFAULT format('guid#%s',uuid_generate_v4 ()),
        sk TEXT not null check (length(sk) < 500),
        tk TEXT DEFAULT format('guid#%s',uuid_generate_v4 ()),
        form jsonb not null,
        active BOOLEAN NOT NULL DEFAULT true,
        created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
        updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
        owner TEXT
    );

--  _____           _
-- |_   _|         | |
--   | |  _ __   __| | _____  __
--   | | | '_ \ / _` |/ _ \ \/ /
--  _| |_| | | | (_| |  __/>  <
-- |_____|_| |_|\__,_|\___/_/\_\
----------------
-- INDEX: Create Indices
----------------

CREATE UNIQUE INDEX IF NOT EXISTS one_first_idx ON base_0_0_1.one(pk,sk);
CREATE UNIQUE INDEX IF NOT EXISTS one_second_idx ON base_0_0_1.one(sk,tk);
-- speed up adoptees query by bounding rect
CREATE UNIQUE INDEX IF NOT EXISTS one_second_flip_idx ON base_0_0_1.one(tk, sk);


--  _____                    _         _
-- |  __ \                  (_)       (_)
-- | |__) |__ _ __ _ __ ___  _ ___ ___ _  ___  _ __  ___
-- |  ___/ _ \ '__| '_ ` _ \| / __/ __| |/ _ \| '_ \/ __|
-- | |  |  __/ |  | | | | | | \__ \__ \ | (_) | | | \__ \
-- |_|   \___|_|  |_| |_| |_|_|___/___/_|\___/|_| |_|___/

----------------
-- GRANT: Permissions
----------------

GRANT select on base_0_0_1.one to api_guest; -- R
GRANT insert on base_0_0_1.one to api_guest; -- C

GRANT select on base_0_0_1.one  to api_user; -- R
GRANT insert on base_0_0_1.one  to api_user; -- C
GRANT update on base_0_0_1.one  to api_user; -- U
GRANT delete on base_0_0_1.one  to api_user; -- D

GRANT select on base_0_0_1.one  to api_admin; -- R
GRANT insert on base_0_0_1.one  to api_admin; -- C
GRANT update on base_0_0_1.one  to api_admin; -- U
GRANT delete on base_0_0_1.one  to api_admin; -- D

GRANT insert on base_0_0_1.one  to event_logger_role; -- C ... 'app' only
GRANT select on base_0_0_1.one  to event_logger_role; -- R ... 'owner', 'app'
