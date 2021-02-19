
\c one_db
--------------
-- Environment
--------------
-- TODO 1.4.2: adoptee isnt unique enough, add user key

-- TODO ?.?.?: When adopter is deactivated then deactivate all adoptions by that adopter
-- TODO ?.?.?: put admin hold on adopter. test for active adopter record during signin. When active is false then adopter is the same as deleted.
-- DONE 1.2.1: changed reg_id to pk
-- DONE ?.?.?: change reg_type to sk

-- DONE 1.2.1: Change "process" type to "event" type
-- DONE 1.2.1: Change Process_logger to event_logger
-- DONE 1.2.1: Change 1_2_0 to 1_2_1
-- DONE 1.2.1: Dont allow drain to be adopted more than once ... uses index
-- DONE 1.2.0: Add Adpotee
-- DONE 1.2.0: Rename schema from one_schema_1_2_1 to one_version_1_2_1

\set lb_env `echo "'$LB_ENV'"`
\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
\set lb_guest_password `echo "'$LB_GUEST_PASSWORD'"`
\set lb_woden `echo "'$LB_WODEN'"`


select :lb_env as lb_env;
select :lb_guest_password as lb_guest_password;
select :postgres_jwt_secret as postgres_jwt_secret;
select :lb_woden as lb_woden, pg_typeof(:lb_woden::JSONB) as type;

--------------
-- DATABASE
--------------

-- DROP DATABASE IF EXISTS one_db;
-- CREATE DATABASE one_db;

---------------
-- Security, dont let users create anything in public
---------------
-- REVOKE CREATE ON SCHEMA public FROM PUBLIC;

--\c one_db
---------------
-- SCHEMA: Create Schema
---------------
CREATE SCHEMA if not exists one_base;

SET search_path TO one_base, public;

--------------
-- TABLE: Create Table
--------------
/*
GS1 pk,sk
Access pattern
signin,

adoptee
woden
form {"id": "woden@citizenlabs.org", "app": "Adopt-A-Drain", "key": "c3543d9d-883e-4158-a442-8c0624409cdd", "org": "CitizenLabs", "name": "woden@citizenlabs.org", "type": "woden", "roles": "woden,admin", "password": "$2a$06$CHcQOw31Jak0Eh8VH0qW1ObYmg4pRQOGjqg.86/jz2pJ9bxESKWUm"}
adopter
reg_{"id": "johndoe@citizenlabs.org", "key": "11a15030-3d71-49cc-9d79-c9b48f575ce1", "name": "JohnDoe@citizenlabs.org", "type": "adopter", "password": "$2a$06$c4Rngjb26A/J9XvHIXlEPuhN4dUhJU1m0mmeQ7wz8tWDDHQS2fxWa"}
adoptee
{"lat": 42.01, "lon": -84.01, "name": "some opt name", "type": "adoptee", "drain_id": "gr12345667", "adopter_key": "11a15030-3d71-49cc-9d79-c9b48f575ce1"}
pk, sk, tk,            form
woden,   woden, woden@citzenlabs.org,
adoptee,
j@j.com

*/

create table if not exists
    one_base.one  (
        pk TEXT DEFAULT uuid_generate_v4 (),
        sk varchar(256) not null check (length(sk) < 256),
        tk varchar(256) not null check (length(sk) < 256),
        form jsonb not null,
        active BOOLEAN NOT NULL DEFAULT true,
        created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
        updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
    );
----------------
-- INDEX: Create Index
-- * index automatically go in the parent table's schema
----------------
CREATE UNIQUE INDEX IF NOT EXISTS one_first_idx ON one_base.one(pk,sk);
CREATE UNIQUE INDEX IF NOT EXISTS one_second_idx ON one_base.one(sk,tk);
-- speed up adoptees query by bounding rect
CREATE UNIQUE INDEX IF NOT EXISTS one_second_flip_idx ON one_base.one(tk, sk);

-- GRANT: Grant Table Permissions
grant insert on one_base.one  to guest_one; -- C
grant select on one_base.one  to guest_one; -- R, signin

grant insert on one_base.one  to editor_one; -- C
grant update on one_base.one  to editor_one; -- U
grant select on one_base.one  to editor_one; -- R
grant delete on one_base.one  to editor_one; -- R

grant insert on one_base.one  to event_logger_role; -- C

----------------
-- FUNCTION: Table Trigger
----------------

/*
CREATE OR REPLACE FUNCTION one_base.one_upsert_trigger_func() RETURNS TRIGGER
AS $$
Declare _token TEXT;
Declare _payload_claims JSON;
Declare _payload_claims_tmpl TEXT;
Declare _form JSONB;
Declare _pw TEXT;
BEGIN
    IF (TG_OP = 'INSERT') THEN
      IF (NEW.sk = 'event') then
        NEW.sk := format('event#%s', NEW.pk);
        -- events can have an additional type tucked into form
        NEW.pk := COALESCE(current_setting('request.jwt.claim.jti','t'),'guest');

      ELSEIF (NEW.form ->> 'type' = 'adopter' or NEW.form ->> 'type' = 'woden') then

        _form := format('{"id":"%s","key":"%s","name":"%s","password":"%s"}'::TEXT,
          LOWER(NEW.form ->> 'name'),
          NEW.pk,
          NEW.form ->> 'name',
          crypt(NEW.form ->> 'password', gen_salt('bf')) )::JSONB;

        NEW.pk := LOWER(NEW.form ->> 'name');
        NEW.sk := format('profile#%s',NEW.sk);
        NEW.form := NEW.form  || _form;

      ELSEIF (NEW.form ->> 'type' = 'adoptee') then
          NEW.sk := format('adoptee#%s#%s',
                                  COALESCE(current_setting('request.jwt.claim.key','t'),'8a39dc33-0c6c-4b4e-bdb8-3829af311dd8'),
                                  NEW.form ->> 'drain_id');
          -- NEW.sk := format('adoptee#%s', NEW.form ->> 'drain_id');
          NEW.tk := 'adoptee';
          NEW.pk := COALESCE(current_setting('request.jwt.claim.jti','t'),'test@citizenlabs.org');

      END IF;

    ELSEIF (TG_OP = 'UPDATE') THEN

       NEW.updated := CURRENT_TIMESTAMP;

    END IF;

    RETURN NEW;
END; $$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_base.one_upsert_trigger_func  to guest_one;
grant EXECUTE on FUNCTION one_base.one_upsert_trigger_func  to editor_one;

----------------
-- TRIGGER: Create Table Trigger
----------------
CREATE TRIGGER one_ins_upd_trigger
 BEFORE INSERT ON one_base.one
 FOR EACH ROW
 EXECUTE PROCEDURE one_base.one_upsert_trigger_func ();

grant TRIGGER on one_base.one  to guest_one;
grant TRIGGER on one_base.one  to editor_one;
*/

----------------
-- USER: Setup woden user
----------------
insert into one_base.one  (sk, tk, form) values ( :lb_woden::JSONB ->> 'name','woden',(:lb_woden::JSONB || '{"type":"woden", "roles":"woden,admin"}'::JSONB) );


  -----------------
  -- FUNCTION: Create event_logger(_form JSONB)
  -----------------

  CREATE OR REPLACE FUNCTION one_base.event_logger(form JSONB) RETURNS JSONB
  AS $$
    Declare rc jsonb;
    Declare _model_user JSONB;
    Declare _form JSONB;
    Declare _jwt_role TEXT;
    Declare _validation JSONB;
    Declare _password TEXT;

    BEGIN
      _form := form;
      _validation := one_base.event_logger_validate(_form);
      if _validation ->> 'status' != '200' then
          return _validation;
      end if;

      if _form ? 'id' then
          return '{"status": "400", "msg": "Update not supported"}'::JSONB;
      else

        BEGIN
                INSERT INTO one_base.one
                    (sk, tk, form)
                VALUES
                    ('event',_form ->> 'type', _form);
        EXCEPTION
            WHEN unique_violation THEN
                return '{"status":"400", "msg":"Bad event Request, duplicate error"}'::JSONB;
            WHEN check_violation then
                return '{"status":"400", "msg":"Bad event Request, validation error"}'::JSONB;
            WHEN others then
                return format('{"status":"500", "msg":"Unknown event insertion error", "SQLSTATE":"%s"}',SQLSTATE)::JSONB;
        END;
      end if;

      rc := '{"msg": "OK", "status": "200"}'::JSONB;
      return rc;
    END;
  $$ LANGUAGE plpgsql;
  -- GRANT: Grant Execute
  grant EXECUTE on FUNCTION one_base.event_logger(JSONB) to event_logger_role; -- upsert
  grant EXECUTE on FUNCTION one_base.event_logger(JSONB) to editor_one; -- upsert

  -----------------
  -- FUNCTION: Create event_logger_validate(form JSONB)
  -----------------

  CREATE OR REPLACE FUNCTION one_base.event_logger_validate(form JSONB) RETURNS JSONB
  AS $$

    BEGIN

      if not(form ? 'type' ) then
         return '{"status":"400","msg":"Bad Request, event_logger_validate is missing one or more form attributes"}'::JSONB;
      end if;
      if form ? 'password'  then
         return '{"status":"409","msg":"Conflict, password should not be included."}'::JSONB;
      end if;
      return '{"status": "200"}'::JSONB;
    END;
  $$ LANGUAGE plpgsql;
  -- GRANT: Grant Execute
  grant EXECUTE on FUNCTION one_base.event_logger_validate(JSONB) to event_logger_role; -- upsert
  grant EXECUTE on FUNCTION one_base.event_logger_validate(JSONB) to editor_one; -- upsert

  ---------------------
  -- GRANT: GRANT Schema permissions
  ---------------------

  -- GRANT: Grant Table permissions to event_logger_role
  grant insert on one_base.one  to event_logger_role; -- C ... 'app' only
  grant select on one_base.one  to event_logger_role; -- R ... 'owner', 'app'

  -- TRIGGER
  -- event_logger_role should inhert regi ster trigger privileges
  -- GRANT: Grant Trigger Permissions to event_logger_role
  --grant EXECUTE on FUNCTION one_base.one_upsert_trigger_func  to event_logger_role;

  ------------
  -- FUNCTION: Create is_valid_token(_token TEXT, expected_role TEXT)
  -----------------

  CREATE OR REPLACE FUNCTION one_base.is_valid_token(_token TEXT, expected_role TEXT) RETURNS Boolean
  AS $$

    DECLARE good Boolean;
    DECLARE actual_role TEXT;

  BEGIN
    -- does role in token match expected role
    -- use db parameter app.settings.jwt_secret
    -- event the token
    -- return true/false
    good:=false;

    select payload ->> 'role' as role into actual_role  from verify(_token, current_setting('app.settings.jwt_secret'));

    if expected_role = actual_role then
      good := true;
    end if;

    RETURN good;
  END;  $$ LANGUAGE plpgsql;
  -- GRANT: Grant Function Permissions
  grant EXECUTE on FUNCTION one_base.is_valid_token(TEXT, TEXT) to guest_one; -- C
  grant EXECUTE on FUNCTION one_base.is_valid_token(TEXT, TEXT) to editor_one; -- C
