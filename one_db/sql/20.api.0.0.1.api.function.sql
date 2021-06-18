\c one_db

CREATE SCHEMA if not exists api_0_0_1;

SET search_path TO api_0_0_1, base_0_0_1, public;
--------------
-- Environment
--------------


--\set lb _env `echo "'$LB _ENV'"`
--\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
--\set lb _guest_password `echo "'$LB _GUEST_PASSWORD'"`
--\set postgres_jwt_claims `echo "'$POSTGRES_JWT_CLAIMS'"`
--\set api_scope     `echo "'$API_SCOPE'"`

--select :api_scope as api_scope;


---------------
-- GRANT: Grant Schema Permissions
---------------

grant usage on schema api_0_0_1 to api_guest;
grant usage on schema api_0_0_1 to api_user;

grant usage on schema api_0_0_1 to api_authenticator;
