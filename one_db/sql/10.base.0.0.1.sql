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

\set lb_env `echo "'$LB_ENV'"`
\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
\set lb_guest_password `echo "'$LB_GUEST_PASSWORD'"`
\set lb_jwt_claims `echo "'$LB_JWT_CLAIMS'"`
\set api_scope     `echo "'$API_SCOPE'"`


select :lb_env as lb_env;
select :lb_guest_password as lb_guest_password;
select :postgres_jwt_secret as postgres_jwt_secret;
select :lb_jwt_claims as lb_jwt_claims;
select :api_scope as api_scope;


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

ALTER DATABASE one_db SET "app.lb_env" To :lb_env;

--ALTER DATABASE one_db SET "app.lb_woden" To :lb_woden;

--ALTER DATABASE one_db SET "app.lb_guest_one" To '{"role":"guest_one"}';

--ALTER DATABASE one_db SET "app.lb_editor_one" To '{"role":"editor_one", "key":"afoekey012345"}';

ALTER DATABASE one_db SET "app.lb_jwt_claims" To :lb_jwt_claims;

---------------
-- GRANT: Grant Schema Permissions
---------------

--   _____      _
--  / ____|    | |
-- | (___   ___| |__   ___ _ __ ___   __ _
--  \___ \ / __| '_ \ / _ \ '_ ` _ \ / _` |
--  ____) | (__| | | |  __/ | | | | | (_| |
-- |_____/ \___|_| |_|\___|_| |_| |_|\__,_|


grant usage on schema base_0_0_1 to event_logger_role;
grant usage on schema base_0_0_1 to api_guest;

grant usage on schema base_0_0_1 to event_logger_role;

grant usage on schema base_0_0_1 to api_guest;
---------------
-- SCHEMA: Set Schema Path
---------------

SET search_path TO base_0_0_1, base_0_0_1, public;

----------------
-- TYPE: Create Types
----------------

CREATE TYPE base_0_0_1.jwt_token AS (
  token text
);

--  _______    _     _
-- |__   __|  | |   | |
--    | | __ _| |__ | | ___
--    | |/ _` | '_ \| |/ _ \
--    | | (_| | |_) | |  __/
--    |_|\__,_|_.__/|_|\___|

create table if not exists
    base_0_0_1.one  (
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



grant select on base_0_0_1.one to api_guest; -- R
grant insert on base_0_0_1.one to api_guest; -- C

grant select on base_0_0_1.one  to api_user; -- R
grant insert on base_0_0_1.one  to api_user; -- C
grant update on base_0_0_1.one  to api_user; -- U
grant delete on base_0_0_1.one  to api_user; -- D
--=============================================================================
--=============================================================================
--=============================================================================


-- Functions
--  ______                _   _
-- |  ____|              | | (_)
-- | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
-- |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
-- | |  | |_| | | | | (__| |_| | (_) | | | \__ \
-- |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/



--=============================================================================
-- TIME
--=============================================================================
CREATE OR REPLACE FUNCTION base_0_0_1.time() RETURNS JSONB
AS $$
  declare _time timestamp;
  declare _zone TEXT;
BEGIN
  SELECT NOW()::timestamp into _time ;
  SELECT current_setting('TIMEZONE') into _zone;
  return format('{"status":"200", "msg":"OK", "time": "%s", "zone":"%s"}',_time,_zone)::JSONB;
END;
$$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.time() to api_guest;
grant EXECUTE on FUNCTION base_0_0_1.time() to api_user;

  -----------------
  -- FUNCTION: Create event_logger(_form JSONB)
  -----------------

  CREATE OR REPLACE FUNCTION base_0_0_1.event_logger(form JSONB) RETURNS JSONB
  AS $$
    Declare rc jsonb;
    Declare _model_user JSONB;
    Declare _form JSONB;
    Declare _jwt_role TEXT;
    Declare _validation JSONB;
    Declare _password TEXT;

    BEGIN
      _form := form;
      _validation := base_0_0_1.event_logger_validate(_form);
      if _validation ->> 'status' != '200' then
          return _validation;
      end if;

      if _form ? 'id' then
          return '{"status": "400", "msg": "Update not supported"}'::JSONB;
      else

        BEGIN
                INSERT INTO base_0_0_1.one
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

  -----------------
  -- FUNCTION: Create event_logger_validate(form JSONB)
  -----------------

  CREATE OR REPLACE FUNCTION base_0_0_1.event_logger_validate(form JSONB) RETURNS JSONB
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
  grant EXECUTE on FUNCTION base_0_0_1.event_logger_validate(JSONB) to event_logger_role; -- upsert
  --grant EXECUTE on FUNCTION base_0_0_1.event_logger_validate(JSONB) to editor_one; -- upsert

  ---------------------
  -- GRANT: GRANT Schema permissions
  ---------------------

  -- GRANT: Grant Table permissions to event_logger_role
  grant insert on base_0_0_1.one  to event_logger_role; -- C ... 'app' only
  grant select on base_0_0_1.one  to event_logger_role; -- R ... 'owner', 'app'


  ------------
  -- FUNCTION: Create is_valid_token(_token TEXT, expected_role TEXT)
  -----------------

  CREATE OR REPLACE FUNCTION base_0_0_1.is_valid_token(_token TEXT, expected_role TEXT) RETURNS Boolean
  AS $$

    DECLARE good Boolean;
    DECLARE actual_role TEXT;

  BEGIN
  --raise notice 'is_valid_token 1';
    -- is token null
    -- does role in token match expected role
    -- use db parameter app.settings.jwt_secret
    -- event the token
    -- return true/false
    --raise notice 'is_valid_token %',_token;
    if _token is NULL
      or expected_role is NULL
    then
      return false;
    end if;

    good:=false;
    BEGIN
      select payload ->> 'scope' as role into actual_role
        from verify(replace(_token,'Bearer ',''), current_setting('app.settings.jwt_secret'));
    EXCEPTION
      when sqlstate '22021' then
      RAISE NOTICE 'character_not_in_repertoire sqlstate %', sqlstate;

        RETURN false;
    	when others then
        RAISE NOTICE 'is_valid_token has unhandled sqlstate %', sqlstate;
        RETURN false;
    END;
    if strpos(actual_role,expected_role) > 0 then
      good := true;
    end if;

    RETURN good;
  END;  $$ LANGUAGE plpgsql;
  -- GRANT: Grant Function Permissions

  grant EXECUTE on FUNCTION base_0_0_1.is_valid_token(TEXT, TEXT) to api_guest;


--=============================================================================
-- QUERY
--=============================================================================

-- Query
--   ____
--  / __  \
-- | |  | |_   _  ___ _ __ _   _
-- | |  | | | | |/ _ \ '__| | | |
-- | |__| | |_| |  __/ |  | |_| |
--  \___\_\\__,_|\___|_|   \__, |
--                          __/ |
--                         |___/


CREATE OR REPLACE FUNCTION base_0_0_1.query(criteria JSON) RETURNS JSONB
AS $$
  declare _criteria JSONB;
  declare _result JSONB;
BEGIN
	-- select by pk and sk
	-- or sk and tk
	-- use wildcard * in any position
	-- criteria is {pk:"", sk:""} or {sk:"", tk:""}
	BEGIN
    _criteria := criteria::JSONB;
	    -- validate the criteia
    if _criteria ? 'pk' and _criteria ? 'sk' then
      if _criteria ->> 'sk' = '*' then
          SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
            FROM base_0_0_1.one u
            where pk = _criteria ->> 'pk';
          return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      else
          SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
            FROM base_0_0_1.one u
            where pk = _criteria ->> 'pk'  and sk = _criteria ->> 'sk';
          return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      end if;
    elsif _criteria ? 'sk' and _criteria ? 'tk' then
      if _criteria ->> 'tk' = '*' then
        SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
          FROM base_0_0_1.one u
          where sk = _criteria ->> 'sk';
        return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      else
        SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
          FROM base_0_0_1.one u
          where sk = _criteria ->> 'sk' and tk = _criteria ->> 'tk';
        return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      end if;
    elsif _criteria ? 'xk' and _criteria ? 'yk' then
      if _criteria ->> 'yk' = '*' then
        SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
          FROM base_0_0_1.one u
          where tk = _criteria ->> 'xk';
        return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      else
        SELECT array_to_json(array_agg(to_jsonb(u) #- '{form,password}' )) into _result
          FROM base_0_0_1.one u
          where tk = _criteria ->> 'xk' and sk = _criteria ->> 'yk';
        return format('{"status":"200", "msg":"OK", "selection":%s}', _result)::JSONB;
      end if;
    else
      return format('{"status:"400","msg":"Bad Request", "extra":"%s"}',sqlstate)::JSONB;

    end if;

  EXCEPTION
    	when others then
        return '{"status":"400","msg":"Bad Request"}'::JSONB;

	END;

END;
$$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.query(JSON) to api_guest;
grant EXECUTE on FUNCTION base_0_0_1.query(JSON) to api_user;


--=============================================================================
-- DELETE
--=============================================================================


-- Delete
--  _____       _      _
-- |  __ \     | |    | |
-- | |  | | ___| | ___| |_ ___
-- | |  | |/ _ \ |/ _ \ __/ _ \
-- | |__| |  __/ |  __/ ||  __/
-- |_____/ \___|_|\___|\__\___|

-- {pk,sk}
-- ToDo: limit delete to users personal records.

CREATE OR REPLACE FUNCTION base_0_0_1.delete(pkcriteria JSON) RETURNS JSONB
AS $$
  declare _crit JSONB;
  declare _result record;
  declare _status TEXT;
  declare _msg TEXT;
  declare _rc JSONB;
  BEGIN
    --raise notice 'delete 1';
      _crit := pkcriteria::JSONB;

      --if not(_crit ? 'pk') or not(_crit ? 'sk') then
      --  return format('{"status":"400", "msg":"Bad Request", "criteria":%s}',_crit)::JSONB ;
      --end if;
      --raise notice 'delete 1';

      -- there can be only one
      if _crit ? 'pk' and _crit ? 'sk' then -- {pk sk}
        Delete from base_0_0_1.one
          where pk=_crit ->> 'pk' and sk=_crit ->> 'sk'
          returning * into _result;
      elsif _crit ? 'sk' and _crit ? 'tk' then -- {sk tk}
        Delete from base_0_0_1.one
          where sk=_crit ->> 'sk' and tk=_crit ->> 'tk'
          returning * into _result;
      else
        return format('{"status":"400", "msg":"Bad Request", "criteria":%s}',_crit)::JSONB ;
      end if;

      _rc :=  to_jsonb(_result)  #- '{form,password}';

      if _rc ->> 'pk' is NULL then
        return format('{"status":"404", "msg":"Not Found", "criteria":%s}',_crit)::JSONB ;
      end if;

      return format('{"status":"200", "msg":"OK", "criteria":%s, "deletion":%s}',_crit,_rc::TEXT)::JSONB ;


  EXCEPTION
      when sqlstate 'PT400' then
          return format('{"status":"404", "msg":"Not Found", "criteria":%s}',_crit)::JSONB ;
      when sqlstate 'PT401' then
        return format('{"status":"401", "msg":"Unauthorized", "criteria":%s}',_crit)::JSONB ;
      when sqlstate 'PT403' then
        return format('{"status":"403", "msg":"Forbidden", "criteria":%s}',_crit)::JSONB ;
      when sqlstate 'PT404' then
        return format('{"status":"404", "msg":"Not Found", "criteria":%s}',_crit)::JSONB ;
      when others then
        RAISE NOTICE '5 Beyond here there be dragons! %', sqlstate;
        return format('{"status":"%s", "msg":"Internal Server Error", "criteria":%s}',sqlstate,_crit)::JSONB ;
  END;
$$ LANGUAGE plpgsql;

-- GRANT: Grant Execute

grant EXECUTE on FUNCTION base_0_0_1.delete(JSON) to api_user;

--=============================================================================
-- INSERT
--=============================================================================
-- returns {}

-- Insert
--  _____                     _
-- |_   _|                   | |
--   | |  _ __  ___  ___ _ __| |_
--   | | | '_ \/ __|/ _ \ '__| __|
-- _ | |_| | | \__ \  __/ |  | |_
-- |_____|_| |_|___/\___|_|   \__|
-- {pk, sk, tk}
-- {pk, sk}
-- {sk, tk}

-- todo: add user id to inserted record ... :""



CREATE OR REPLACE FUNCTION base_0_0_1.insert(_chelate JSONB) RETURNS JSONB
AS $$
  --declare _chelate JSONB;
  declare _form JSONB;
  declare _result record;
  declare _extra TEXT;
  declare _scope TEXT; -- soft role
  declare _owner TEXT; -- who is inserting this record
BEGIN
  --raise notice 'insert app.scope %', COALESCE(current_setting('app.scope','t'), 'guest');
  --raise notice 'insert app.user %', COALESCE(current_setting('app.user','t'), 'system');

  _scope := COALESCE(current_setting('app.scope','t'), 'guest');
  _owner := COALESCE(current_setting('app.user','t'), 'system');

  _form := (_chelate ->> 'form')::JSONB;
  --_form := _form || format('{"owner":"%s"}',_owner)::JSONB;
	  -- insert
  if not(_chelate ? 'form') then
    return '{"status":"400", "msg":"Bad Request", "extra":"chelate is missing form."}'::JSONB;

  elsif _chelate ? 'pk' and _chelate ? 'sk' and _chelate ? 'tk' then
    _extra := 'A';
    insert into base_0_0_1.one (pk,sk,tk,form,owner)
      values ((_chelate ->> 'pk'), (_chelate ->> 'sk'), (_chelate ->> 'tk'), _form, _owner)
      returning * into _result;

  elsif _chelate ? 'pk' and _chelate ? 'sk' then
    _extra := 'B';
    insert into base_0_0_1.one (pk,sk,form,owner)
      values ((_chelate ->> 'pk'), (_chelate ->> 'sk') ,_form, _owner)
      returning * into _result;

  elsif _chelate ? 'sk' and _chelate ? 'tk' then
    _extra := 'C';
    insert into base_0_0_1.one (sk,tk,form,owner)
      values ((_chelate ->> 'sk'), (_chelate ->> 'tk') ,_form, _owner)
      returning * into _result;

  elsif _chelate ? 'sk' then
    _extra := 'D';
    insert into base_0_0_1.one (sk,form,owner)
      values (
              (_chelate ->> 'sk'),
              _form, _owner) returning * into _result;
  else
    return '{"status":"400", "msg":"Bad Request", "extra":"failed insert"}'::JSONB;
  end if;
      --raise notice 'insert 3';
	return format('{"status":"200", "msg":"OK", "insertion": %s}',(to_jsonb(_result)#- '{form,password}')::TEXT)::JSONB;

EXCEPTION
     -- when sqlstate 'PT400' then
     --   return '{"status":"400", "msg":"Bad Request"}'::JSONB;
      when unique_violation then
        return '{"status":"409", "msg":"Duplicate"}'::JSONB;
      when others then
        RAISE NOTICE 'Insert Beyond here there be dragons! %', sqlstate;
        return format('{"status":"%s", "msg":"Unhandled","extra":"%s"}', sqlstate, _extra)::JSONB;
END;
$$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.insert(JSONB) to api_guest;
grant EXECUTE on FUNCTION base_0_0_1.insert(JSONB) to api_user;


--=======================================
-- Changed_key
--=======================================

CREATE OR REPLACE FUNCTION base_0_0_1.changed_key(chelate JSONB) RETURNS BOOLEAN
AS $$
	declare _rec record;
	declare _form JSONB;
	declare _value TEXT;
	declare _fld TEXT;
BEGIN
  -- determines if one of the keys has been changed if so then return true
  _form := chelate ->> 'form';

  FOR _rec IN Select * from jsonb_each_text(_form)
  LOOP

    _value := format('%s#%s',_rec.key, _rec.value) ;
    _fld := format('%s#',_rec.key);

    if strpos(chelate ->> 'pk', _fld) = 1 then
  		if chelate ->> 'pk' != _value then
  			return true;
  	  end if;
  	elsif strpos(chelate ->> 'sk', _fld) = 1 then
  		if chelate ->> 'sk' != _value then
  			return true;
  	  end if;
  	elsif strpos(chelate ->> 'tk', _fld) = 1 then
  		if chelate ->> 'tk' != _value then
  			return true;
      end if;
    end if;

  END LOOP;

  return false;
END;
$$ LANGUAGE plpgsql;


grant EXECUTE on FUNCTION base_0_0_1.changed_key(JSONB) to api_user;

  --=======================================
  -- Chelate
  --=======================================
CREATE OR REPLACE FUNCTION base_0_0_1.chelate(chelate JSONB) RETURNS JSONB
AS $$
   DECLARE _rec record;
   DECLARE _fld TEXT;
   DECLARE _form jsonb;
   DECLARE _value TEXT;
   DECLARE _key TEXT;
   DECLARE _out JSONB;
BEGIN
  -- creates proposed chelate to update
  -- created is added on insert, it will be in the record and doesnt need to be added
  -- updated is changed everytime
  --   GUID never changes
  _form := chelate ->> 'form';
  -- UPDATED date
  _out := format('{"updated": "%s"}', NOW());

  -- get outter keys of chelate
  FOR _rec IN SELECT * FROM jsonb_each_text(chelate)
  LOOP
    _key := _rec.key;
    _fld := split_part(_rec.value, '#', 1);

    if _key = 'form' then
       -- copy the whole form att
       _out := _out || format('{"form": %s}', _form::TEXT)::JSONB;
    elsif  _form ->> _fld is NULL then -- key not in form
       -- is a constant, a guid, created, keep the current value
      if not(_fld = 'updated') then -- skip updated field
         _out := _out || format('{"%s":"%s"}', _key, chelate ->> _key)::JSONB;
      end if;
    else
       -- this is a key
      _out := _out || format('{"%s":"%s#%s"}', _key, _fld, _form ->> _fld)::JSONB;

    end if;
  END LOOP;

  return _out;

END;
$$ LANGUAGE plpgsql;


grant EXECUTE on FUNCTION base_0_0_1.chelate(JSONB) to api_user;

  --=======================================
  -- Update
  --=======================================


-- Update
--  _    _           _       _
-- | |  | |         | |     | |
-- | |  | |_ __   __| | __ _| |_ ___
-- | |  | | '_ \ / _` |/ _` | __/ _ \
-- | |__| | |_) | (_| | (_| | ||  __/
--  \____/| .__/ \__,_|\__,_|\__\___|
--        | |
--        |_|

  -- Handles:
  --   No change
  --   Form Change only (no key change)
  --   Single Key Change only
  --   Key Change with Form change
  --   GUID never changes

  CREATE OR REPLACE FUNCTION base_0_0_1.update(chelate JSON) RETURNS JSONB
    AS $$
      declare _chelate JSONB;
      declare old_chelate JSONB;
      declare new_chelate JSONB;
      DECLARE v_RowCountInt  Int;
      declare _result record;
      --DECLARE new_form JSONB;
    BEGIN
    --raise notice 'update 1';
        _chelate := chelate::JSONB;
        -- primary key update only
        -- form must be provided
        if not(_chelate ? 'pk'
                and _chelate ? 'sk'
                and _chelate ? 'form') then

           return '{"status":"400", "msg":"Bad Request"}'::JSONB;
        end if;
        --raise notice 'update 1';

        if base_0_0_1.changed_key(_chelate) then
        --raise notice 'update 1';

          -- update keys and form
        	-- Select and Merge
  		      SELECT to_jsonb(r) into old_chelate
    	        from (
    	         Select *
      		      from base_0_0_1.one
      		      where pk = (_chelate ->> 'pk') and sk = (_chelate ->> 'sk')
    	        ) r;
          --raise notice 'old chelate %', old_chelate;
          if old_chelate is NULL then
            return '{"status":"404", "msg":"Not Found"}'::JSONB;
          end if;
          --raise notice 'new ', new_form;
          if not(_chelate ? 'tk') then
  	        _chelate := _chelate || format('{"tk":"%s"}',(old_chelate ->> 'tk'))::JSONB;
  	      end if;
        	-- make proper record
          new_chelate := base_0_0_1.chelate(_chelate);
        	-- Delete old
        	Delete from base_0_0_1.one
            where pk = _chelate ->> 'pk' and sk = _chelate ->> 'sk';
        	-- Insert new
      		insert into base_0_0_1.one (pk,sk,tk,form)
      		  values ((new_chelate ->> 'pk'),
      		          (new_chelate ->> 'sk'),
      		          (new_chelate ->> 'tk'),
      		          (new_chelate ->> 'form')::JSONB)
                    returning * into _result;
        else
        --raise notice 'update 1';

    	    -- update the form only
    	    update base_0_0_1.one
    	      set
    	        form = form || (_chelate ->> 'form')::JSONB,
    	        updated = NOW()
    	      where
    	        pk = (_chelate ->> 'pk') and
    	        sk = (_chelate ->> 'sk')
              returning * into _result;

          if not(FOUND) then
             return '{"status":"404", "msg":"Not Found"}'::JSONB;
          end if;
    	  end if;

        return format('{"status":"200","msg":"OK","updation":%s}',(to_jsonb(_result) #- '{form,password}')::TEXT)::JSONB;
    END;
    $$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.update(JSON) to api_user;
