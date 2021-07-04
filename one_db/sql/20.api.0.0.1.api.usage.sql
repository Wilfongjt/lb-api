\c one_db

CREATE SCHEMA if not exists api_0_0_1;

SET search_path TO api_0_0_1, base_0_0_1, public;
--------------
-- Environment
--------------

---------------
-- GRANT: Grant Schema Permissions
---------------

grant usage on schema api_0_0_1 to api_guest;
grant usage on schema api_0_0_1 to api_user;

grant usage on schema api_0_0_1 to api_authenticator;
