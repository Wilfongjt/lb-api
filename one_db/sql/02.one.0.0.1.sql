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
-- DONE 1.2.1: Move adopt_a_drain table to one_base schema
-- DONE 1.2.1: stop insert of duplicate adoptee
-- DONE 1.2.1: add tk to adopter insert
-- DONE 1.2.1: add tk to adoptee insert
-- DONE 1.2.1: add tk to signin

\set lb_env `echo "'$LB_ENV'"`
\set postgres_jwt_secret `echo "'$POSTGRES_JWT_SECRET'"`
\set lb_guest_password `echo "'$LB_GUEST_PASSWORD'"`
\set lb_jwt_claims `echo "'$LB_JWT_CLAIMS'"`

--\set lb_woden `echo "'$LB_WODEN'"`


--select :lb_env as lb_env;
--select :lb_guest_password as lb_guest_password;
--select :postgres_jwt_secret as postgres_jwt_secret;
--select :lb_jwt_claims as lb_jwt_claims, pg_typeof(:lb_jwt_claims::JSONB) as type;
--select :lb_jwt_claims as lb_jwt_claims;

--select current_setting('app.settings.lb_jwt_claims');

--select :lb_woden as lb_woden, pg_typeof(:lb_woden::JSONB) as type;

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
CREATE SCHEMA if not exists one_version_0_0_1;

-- CREATE EXTENSION IF NOT EXISTS pgcrypto;;
-- CREATE EXTENSION IF NOT EXISTS pgtap;;
-- CREATE EXTENSION IF NOT EXISTS pgjwt;;
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-----------------
-- HOST variables
-----------------

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
grant usage on schema one_base to guest_one;
grant usage on schema one_base to editor_one;
grant usage on schema one_base to event_logger_role;

grant usage on schema one_version_0_0_1 to guest_one;
grant usage on schema one_version_0_0_1 to editor_one;
grant usage on schema one_version_0_0_1 to event_logger_role;

---------------
-- SCHEMA: Set Schema Path
---------------

SET search_path TO one_version_0_0_1, one_base, public;

----------------
-- TYPE: Create Types
----------------
/*
CREATE TYPE one_version_0_0_1.woden_token AS (
  woden text
);
*/
CREATE TYPE one_version_0_0_1.jwt_token AS (
  token text
);
--=============================================================================
--=============================================================================
--=============================================================================

------------
-- FUNCTION: Create one_version_0_0_1.signin(form JSON)
------------
--=============================================================================
-- QUERY
--=============================================================================

CREATE OR REPLACE FUNCTION one_version_0_0_1.query(criteria JSON) RETURNS TABLE (results JSONB)
AS $$
  declare _criteria JSONB;
BEGIN
	-- select by pk and sk
	-- or sk and tk
	-- use wildcard * in any position
	-- criteria is {pk:"", sk:""} or {sk:"", tk:""}
	BEGIN
    _criteria := criteria::JSONB;
	    -- validate the criteia
    if not((_criteria ? 'pk' and _criteria ? 'sk')
       or (_criteria ? 'sk' and _criteria ? 'tk')
       or (_criteria ? 'xk' and _criteria ? 'yk')) then
	    --RAISE sqlstate 'PT400' using
		  --     message = 'Bad Request',
		  --     detail = 'Unhandled criteria combination.',
		  --     hint = 'try pk & sk or sk & tk or xk & yk.';
      return QUERY
        select to_jsonb('{"status":"400", "msg":"Bad Request"}'::JSON) ;
    end if;

    if _criteria ? 'pk' and _criteria ? 'sk' then
    	if _criteria ->> 'sk' = '*' then
        -- Select to_jsonb(form)
        -- replace(replace(replace(replace('{"pk":"%1", "sk":"%2", "tk":"%3", "form": %4}','%1', pk),'%2',sk),'%3',tk),'%4',form::TEXT)::JSONB
        return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
        	from one_base.one
        	where pk = _criteria ->> 'pk') r;
      else
      	return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
        	from one_base.one
        	where pk = _criteria ->> 'pk' and sk = _criteria ->> 'sk') r;
      end if;
     elsif _criteria ? 'sk' and _criteria ? 'tk' then
    	if _criteria ->> 'tk' = '*' then
        return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
          from one_base.one
        	where sk = _criteria ->> 'sk') r;
      else
      	return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
          from one_base.one
        	where sk = _criteria ->> 'sk' and tk = _criteria ->> 'tk') r;
      end if;
    elsif _criteria ? 'xk' and _criteria ? 'yk' then
    	if _criteria ->> 'yk' = '*' then
        return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
          from one_base.one
        	where tk = _criteria ->> 'xk') r;
      else
      	return QUERY
          SELECT to_jsonb(r) FROM (SELECT pk,sk,tk,form,active,created,updated
          from one_base.one
        	where tk = _criteria ->> 'xk' and sk = _criteria ->> 'yk') r;
      end if;
    else
      	RAISE sqlstate 'PT400' using
         message = 'Bad Request',
         detail = 'boundary missing attribute(s).',
         hint = 'Your boundary is incomplete.';
    end if;
  EXCEPTION
    	when others then
    	  return QUERY
			    select to_jsonb('{"status":"400", "msg":"Bad Request"}'::JSON) ;
	END;

END;
$$ LANGUAGE plpgsql;


--=============================================================================
-- DELETE
--=============================================================================
CREATE OR REPLACE FUNCTION one_version_0_0_1.delete(pkcriteria JSON) RETURNS JSONB
AS $$
  declare _crit JSONB;
  declare _result record;
  declare _status TEXT;
  declare _msg TEXT;
  BEGIN
    --raise notice 'delete 1';
      _crit := pkcriteria::JSONB;

    --raise notice 'delete 1.1 %', _crit;
    --raise notice '_crit ? pk %' , (_crit ? 'pk') ;
    --raise notice '_crit ? sk %' , (_crit ? 'sk') ;
    --raise notice 'not(_crit ? pk) = %' , not(_crit ? 'pk')  ;
    --raise notice 'not(_crit ? sk) = %' , not(_crit ? 'sk')  ;

    -- raise notice 'not keys = %' , not((_crit ? 'pk') && (_crit ? 'sk')) ;

      if not(_crit ? 'pk') or not(_crit ? 'sk') then
         --raise notice 'result bad request';

        RAISE sqlstate 'PT400' using
          message = 'Bad Request',
          detail = 'delete',
          hint = 'Get your act together!';
      end if;
      --raise notice 'delete 2';
      -- prepare the return values
      Select * into _result
        from one_base.one
        where pk=_crit ->> 'pk' and sk=_crit ->> 'sk';
--raise notice 'delete 3';
      -- do not  fail when record is not found
      if _result is NULL then
      --raise notice 'result is NULL';
        return (SELECT to_jsonb(r) as result
	        from (
               SELECT '{"msg":"Not Found"}'::JSONB as deletion
	        ) r
	      );
      end if;
      --raise notice 'attempt DELETE';

      -- there can be only one
      Delete from one_base.one
        where pk=_crit ->> 'pk' and sk=_crit ->> 'sk';
      -- {pk,sk,tk,form,created,updated,deleted}
      --raise notice 'return DELETE ok %', _result;

      return (SELECT to_jsonb(r) as result
        from (
          SELECT
          (to_jsonb(_result)  #- '{form,password}' )::JSONB as deletion, NOW() as deleted
        ) r
      );

  EXCEPTION
      when sqlstate 'PT400' then
      --RAISE NOTICE '1 Beyond here there be dragons!';

        RAISE sqlstate 'PT400' using
          message = 'Bad Request',
          detail = 'delete',
          hint = 'Get your act together!';

      when sqlstate 'PT401' then
      --RAISE NOTICE '2 Beyond here there be dragons!';

        RAISE sqlstate 'PT401' using
          message = 'Unauthorized',
          detail = 'delete',
          hint = 'No way!';

      when sqlstate 'PT403' then
      --RAISE NOTICE '3 Beyond here there be dragons!';

        RAISE sqlstate 'PT403' using
          message = 'Forbidden',
          detail = 'delete',
          hint = 'You shall not pass!';

      when sqlstate 'PT404' then
      --RAISE NOTICE '4 Beyond here there be dragons!';

        RAISE sqlstate 'PT404' using
          message = 'Not Found',
          detail = 'delete',
          hint = 'Nothing to see here!';

      when others then
        RAISE NOTICE '5 Beyond here there be dragons! %', sqlstate;
        RAISE sqlstate 'PT404' using
          message = 'Not Found',
          detail = 'delete',
          hint = 'Beyond here there be dragons!';

  END;
$$ LANGUAGE plpgsql;

-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.delete(JSON) to editor_one;

--=============================================================================
-- INSERT
--=============================================================================
-- returns {}


CREATE OR REPLACE FUNCTION one_version_0_0_1.insert(chelate JSON) RETURNS JSONB
AS $$
  declare _chelate JSONB;
  declare _form JSONB;
  declare _result record;
BEGIN
      --raise notice 'insert 1';
	_chelate := chelate::JSONB;

	if not(_chelate ? 'sk' and _chelate ? 'form') then
		return '{"status":"400", "msg":"Bad Request"}'::JSONB;
	end if;
	--raise notice 'insert 2';
	_form := (chelate ->> 'form')::JSONB;
	  -- insert
	if not(_chelate ? 'pk') and not(_chelate ? 'tk') then
	    insert into one_base.one (sk,form)
	      values (
	              (_chelate ->> 'sk'),
	              _form) returning * into _result;

	elsif not(_chelate ? 'pk') then
	    insert into one_base.one (sk,tk,form)
	      values (
	              (_chelate ->> 'sk'),
	              (_chelate ->> 'tk'),
	              _form) returning * into _result;
	else
	    insert into one_base.one (pk,sk,tk,form)
	      values ((_chelate ->> 'pk'), (_chelate ->> 'sk'), (_chelate ->> 'tk'), _form)
	      returning * into _result;

	end if;
      --raise notice 'insert 3';
	return format('{"status":"200", "msg":"OK", "insertion": %s}',to_jsonb(_result)::TEXT)::JSONB;

EXCEPTION
     -- when sqlstate 'PT400' then
     --   return '{"status":"400", "msg":"Bad Request"}'::JSONB;
      when unique_violation then
        return '{"status":"409", "msg":"Duplicate"}'::JSONB;
      when others then
        RAISE NOTICE 'Insert Beyond here there be dragons! %', sqlstate;
        return format('{"status":"%s", "msg":"Unhandled"}', sqlstate)::JSONB;
END;
$$ LANGUAGE plpgsql;
--=======================================
-- Changed_key
--=======================================

CREATE OR REPLACE FUNCTION one_version_0_0_1.changed_key(chelate JSONB) RETURNS BOOLEAN
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

grant EXECUTE on FUNCTION one_version_0_0_1.changed_key(JSONB) to editor_one;

  --=======================================
  -- Chelate
  --=======================================
CREATE OR REPLACE FUNCTION one_version_0_0_1.chelate(chelate JSONB) RETURNS JSONB
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

grant EXECUTE on FUNCTION one_version_0_0_1.chelate(JSONB) to editor_one;

  --=======================================
  -- Update
  --=======================================
  -- Handles:
  --   No change
  --   Form Change only (no key change)
  --   Single Key Change only
  --   Key Change with Form change
  --   GUID never changes

  CREATE OR REPLACE FUNCTION one_version_0_0_1.update(chelate JSON) RETURNS JSONB
    AS $$
      declare _chelate JSONB;
      declare old_chelate JSONB;
      declare new_chelate JSONB;
      DECLARE v_RowCountInt  Int;
      declare _result record;
      --DECLARE new_form JSONB;
    BEGIN
        _chelate := chelate::JSONB;
        -- primary key update only
        -- form must be provided
        if not(_chelate ? 'pk'
                and _chelate ? 'sk'
                and _chelate ? 'form') then

           return '{"status":"400", "msg":"Bad Request"}'::JSONB;
        end if;

        if one_version_0_0_1.changed_key(_chelate) then
          -- update keys and form
        	-- Select and Merge
  		      SELECT to_jsonb(r) into old_chelate
    	        from (
    	         Select *
      		      from one_base.one
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
          new_chelate := one_version_0_0_1.chelate(_chelate);
        	-- Delete old
        	Delete from one_base.one
            where pk = _chelate ->> 'pk' and sk = _chelate ->> 'sk';
        	-- Insert new
      		insert into one_base.one (pk,sk,tk,form)
      		  values ((new_chelate ->> 'pk'),
      		          (new_chelate ->> 'sk'),
      		          (new_chelate ->> 'tk'),
      		          (new_chelate ->> 'form')::JSONB)
                    returning * into _result;
        else
    	    -- update the form only
    	    update one_base.one
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

    	  --GET DIAGNOSTICS v_RowCountInt = ROW_COUNT;

        return (SELECT to_jsonb(r) as result
              from (
                SELECT
                '200' as status,
                'OK' as msg,
                _result as updation
              ) r
            );
    END;
    $$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION one_version_0_0_1.update(JSON) to editor_one;

  CREATE OR REPLACE FUNCTION one_version_0_0_1.session_set(name TEXT, value TEXT) RETURNS JSONB
    AS $$
      Declare _form JSONB;
      Declare _user_token TEXT;
    BEGIN

    END;
  $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION one_version_0_0_1.signin(guest_token TEXT,credentials JSON) RETURNS JSONB
  AS $$
    Declare _credentials JSONB;
    Declare _user_token TEXT;
  BEGIN

    if guest_token is NULL
       or not(one_base.is_valid_token(guest_token, 'guest') )
    then
      return '{"status":"403","msg":"Forbidden"}'::JSONB;
    end if;

    if credentials is NULL then
      return '{"status":"400","msg":"Bad Request"}'::JSONB;
    end if;

    -- process here
    _credentials := credentials::JSONB;
    _user_token := NULL;

    if not(_credentials ? 'username'
            and _credentials ? 'password') then    -- validate name and password
        return '{"status":"400","msg":"Bad Request"}'::JSONB;
    end if;

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
           from one_base.one
           where
         			pk = LOWER(format('username#%s', _credentials ->> 'username'))
         			and sk = 'const#USER'
         			and form ->> 'password' = crypt(_credentials ->> 'password', form ->> 'password')
         ) r;

    -- evaluate results
    if _user_token is NULL then
      return '{"status":"404","msg":"Not Found"}'::JSONB;
    end if;
    -- calculate the token
    return format('{"status":"200","msg":"OK","token":"%s"}',_user_token)::JSONB;

  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.signin(TEXT, JSON) to guest_one;
/*
  CREATE OR REPLACE FUNCTION one_version_0_0_1.signin(form JSON) RETURNS JSONB
  AS $$
    -- make token to execute app(JSON)
    declare rc JSONB;
    declare user_token TEXT;
    declare event_error JSONB;
    declare _form JSONB;
    Declare _jwt_role TEXT;
    Declare _model_user JSONB;
    Declare _validation JSONB;
    Declare _pw TEXT;
    DECLARE _fr JSONB;
    DECLARE v_RowCountInt INT;
    BEGIN
      -- claims check
      --_jwt_role := current_setting('request.jwt.claim.role','t');

      if _jwt_role is NULL then
        -- needed for tapps testing only
        _jwt_role := 'guest_one';
      end if;

      if not(_jwt_role = 'guest_one') then
        _validation := '{"status":"PT401", "msg":"UnAuthorized","type":"signin"}'::JSONB;
        PERFORM one_base.event_logger(_validation);
        RAISE sqlstate 'PT401' using
          message = 'Unauthorized',
          detail = 'signin',
          hint = 'Are you a hacker?';
      end if;

      v_RowCountInt := 0;
      _form := form::JSONB;
      -- force a type

      _form := _form || '{"type":"signin"}'::JSONB;
      -- name to lowercase
      --_form := _form || format('{"name":"%s"}', LOWER(_form ->> 'name'))::JSONB;
      -- evaluate the token
      _model_user := current_setting('app.lb_guest_one')::jsonb;
      if not(_model_user ->> 'role' = _jwt_role) then
          _validation := '{"status":"PT401", "msg":"UnauthorizeD","type":"signin"}'::JSONB;
          --_validation := one_base.http_response('401','UnauthorizeD');
          PERFORM one_base.event_logger(_validation);
          RAISE sqlstate 'PT401' using
          message = 'Unauthorized',
            detail = 'signin',
            hint = 'Not what I expected?';
      end if;

      --
      -- validate input form
      -- confirm all required attributes are in form
      -- validate attribute values

      -- confirm all required attributes are in form
      if not(_form ? 'username' and _form ? 'password') then
          -- return '{"status":"PT400", "msg":"Bad Request, missing one or more form attributes.","type":"signin"}'::JSONB;
          RAISE sqlstate 'PT400' using
            message = 'Bad Request',
            detail = 'signin',
            hint = 'Get your act together?';
      end if;

      if not(_form ? 'type' and _form ? 'name' and _form ? 'password') then
          -- return '{"status":"PT400", "msg":"Bad Request, missing one or more form attributes.","type":"signin"}'::JSONB;
          RAISE sqlstate 'PT400' using
            message = 'Bad Request',
            detail = 'signin',
            hint = 'Get your act together?';
      end if;

      -- remove password
      _pw := _form ->> 'password';
      _form := _form - 'password';
      -- validate name and password

      select form - 'password' as form into _fr
      from one_base.adopt_a_drain
      where
        tk IN ('adopter','woden')
        and pk = LOWER(_form ->> 'name')
        and form ->> 'password' = crypt(_pw, form ->> 'password');

      GET DIAGNOSTICS v_RowCountInt = ROW_COUNT;

      if v_RowCountInt = 0 then
        RAISE sqlstate 'PT403' using
          message = 'Forbidden',
          detail = 'signin',
          hint = 'Have you signed up?';
      end if;

      IF _fr is NULL THEN
        -- login failure
        _validation :=  '{"status":"PT403", "msg":"Forbidden","type":"signin"}'::JSONB || _form;
        PERFORM one_base.event_logger(_validation);
        RAISE sqlstate 'PT403' using
          message = 'Forbidden',
          detail = 'signin',
          hint = 'Have you signed up?';
        --return _validation;
      end if;

      -- make user_token
      SELECT public.sign(
        row_to_json(r), current_setting('app.settings.jwt_secret')
      ) AS woden into user_token
      FROM (
        SELECT
          current_setting('app.lb_woden')::JSONB ->> 'org' as iss,
          current_setting('app.lb_woden')::JSONB ->> 'app' as sub,
          _fr ->> 'id' as jti,
          _fr ->> 'key' as key,
          'editor_one'::text as role,
          extract(epoch from now() + '5 minutes'::interval) :: integer as exp
      ) r;
      -- log success
      _validation := _form || '{"status":"200"}'::JSONB;

      --PERFORM one_base.event_logger(_validation);
      -- test for owner account
      -- wrap user_token in JSON
      return (SELECT row_to_json(r) as result
        from (
          SELECT
          '200' as status,
          'OK' as msg,
          user_token as token,
          v_RowCountInt as count
        ) r
      );

    END;
  $$ LANGUAGE plpgsql;
  -- GRANT: Grant Execute
  grant EXECUTE on FUNCTION one_version_0_0_1.signin(JSON) to guest_one;
*/
/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.signin(form JSON) RETURNS JSONB
AS $$
  -- make token to execute app(JSON)
  declare rc JSONB;
  declare user_token TEXT;
  declare event_error JSONB;
  declare _form JSONB;
  Declare _jwt_role TEXT;
  Declare _model_user JSONB;
  Declare _validation JSONB;
  Declare _pw TEXT;
  DECLARE _fr JSONB;
  BEGIN
    -- claims check
    _jwt_role := current_setting('request.jwt.claim.role','t');
    if _jwt_role is NULL then
      -- needed for tapps testing only
      _jwt_role := 'guest_one';
    end if;

    if not(_jwt_role = 'guest_one') then
      _validation := '{"status":"PT401", "msg":"UnAuthorized","type":"signin"}'::JSONB;
      PERFORM one_base.event_logger(_validation);
      RAISE sqlstate 'PT401' using
        message = 'Unauthorized',
        detail = 'signin',
        hint = 'Are you a hacker?';
    end if;

    _form := form::JSONB;
    -- force a type
    _form := _form || '{"type":"signin"}'::JSONB;
    -- name to lowercase
    --_form := _form || format('{"name":"%s"}', LOWER(_form ->> 'name'))::JSONB;
    -- evaluate the token
    _model_user := current_setting('app.lb_guest_one')::jsonb;
    if not(_model_user ->> 'role' = _jwt_role) then
        _validation := '{"status":"PT401", "msg":"UnauthorizeD","type":"signin"}'::JSONB;
        --_validation := one_base.http_response('401','UnauthorizeD');
        PERFORM one_base.event_logger(_validation);
        RAISE sqlstate 'PT401' using
        message = 'Unauthorized',
          detail = 'signin',
          hint = 'Not what I expected?';
    end if;
    --
    -- validate input form
    -- confirm all required attributes are in form
    -- validate attribute values

    -- confirm all required attributes are in form
    if not(_form ? 'type' and _form ? 'name' and _form ? 'password') then
        -- return '{"status":"PT400", "msg":"Bad Request, missing one or more form attributes.","type":"signin"}'::JSONB;
        RAISE sqlstate 'PT400' using
          message = 'Bad Request',
          detail = 'signin',
          hint = 'Get your act together?';
    end if;

    -- remove password
    _pw := _form ->> 'password';
    _form := _form - 'password';
    -- validate name and password

    select form - 'password' as form into _fr
    from one_base.adopt_a_drain
    where
      tk IN ('adopter','woden')
      and pk = LOWER(_form ->> 'name')
      and form ->> 'password' = crypt(_pw, form ->> 'password');

    IF _fr is NULL THEN
      -- login failure
      _validation :=  '{"status":"PT403", "msg":"Forbidden","type":"signin"}'::JSONB || _form;
      PERFORM one_base.event_logger(_validation);
      RAISE sqlstate 'PT403' using
        message = 'Forbidden',
        detail = 'signin',
        hint = 'Have you signed up?';
      --return _validation;
    end if;

    -- make user_token
    SELECT public.sign(
      row_to_json(r), current_setting('app.settings.jwt_secret')
    ) AS woden into user_token
    FROM (
      SELECT
        current_setting('app.lb_woden')::JSONB ->> 'org' as iss,
        current_setting('app.lb_woden')::JSONB ->> 'app' as sub,
        _fr ->> 'id' as jti,
        _fr ->> 'key' as key,
        'editor_one'::text as role,
        extract(epoch from now() + '5 minutes'::interval) :: integer as exp
    ) r;
    -- log success
    _validation := _form || '{"status":"200"}'::JSONB;

    PERFORM one_base.event_logger(_validation);
    -- test for owner account
    -- wrap user_token in JSON
    return (SELECT row_to_json(r) as result
      from (
        SELECT
        user_token as token
      ) r
    );

  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.signin(JSON) to guest_one;
*/
-----------------
-- FUNCTION: Create adopter(form JSON)
-----------------
/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.adopter(form JSON) RETURNS JSONB
AS $$
  Declare rc jsonb;
  Declare _model_adopter JSONB;
  Declare _form JSONB;
  Declare _jwt_role TEXT;
  Declare _validation JSONB;
  Declare _password TEXT;

  BEGIN

    -- claims check
    _jwt_role := current_setting('request.jwt.claim.role','t');
    if _jwt_role is NULL then
      -- assume insert
      -- runs during tests only
      _jwt_role := 'guest_one';
      if form::JSONB ? 'id' then
        _jwt_role := 'editor_one';
      end if;

    end if;

    -- handle multiple tokens
    BEGIN
      _model_adopter := current_setting(format('app.lb_%s',_jwt_role))::jsonb;
    EXCEPTION
      WHEN others then
        _validation := '{"status":"500", "msg":"Unknown ","type":"adopter"}'::JSONB;
        PERFORM one_base.event_logger(_validation);
        RAISE sqlstate 'PT500' using
          message = 'Unknown',
          detail = 'adopter',
          hint = 'Something went sideways.';
    END;
    -- in acceptable roles

    -- type stamp and convert to JSONB
    _form := form::JSONB || '{"type":"adopter"}'::JSONB;
    -- confirm all required attributes are in form
    -- validate attribute values

    -- confirm all required attributes are in form
    if not(_form ? 'type' and _form ? 'name' and _form ? 'password') then
       -- return '{"status":"400","msg":"Bad Request, adopter is missing one or more form attributes","type":"adopter"}'::JSONB;
       RAISE sqlstate 'PT400' using
         message = 'Bad Request',
         detail = 'adopter',
         hint = 'Get your act together?';
    end if;

    -- proper password
    if not (exists(select regexp_matches(form ->> 'password', '^(?=.{8,}$)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W).*$') )) then
       -- return '{"status":"400", "msg":"Bad Request password value.","type":"adopter"}'::JSONB;
       RAISE sqlstate 'PT400' using
         message = 'Bad Request',
         detail = 'adopter',
         hint = 'Have you forgotten your password?';
    end if;
    -- proper name ... name
    if not( exists( select regexp_matches(form ->> 'name', '[a-z\-_0-9]+@[a-z]+\.[a-z]+') ) ) then
       -- return '{"status":"400", "msg":"Bad Request name value.","type":"adopter"}'::JSONB;
       RAISE sqlstate 'PT400' using
         message = 'Bad Request',
         detail = 'adopter',
         hint = 'Expecting an email for your name.';
    end if;

    if _form ? 'id' then
      -- editor
        -- return '{"status": "400", "msg": "Update not YET supported","type":"adopter"}'::JSONB;
        RAISE sqlstate 'PT400' using
          message = 'Bad Request',
          detail = 'adopter',
          hint = 'Update not YET supported.';
    else
      -- guest role
      BEGIN
              INSERT INTO one_base.adopt_a_drain
                  (sk, tk, form)
              VALUES
                  (_form ->> 'name', 'adopter', _form);
      EXCEPTION
          WHEN unique_violation THEN
              _validation := _form || '{"status":"409", "msg":"Conflict, duplicate adopter.","type":"adopter"}'::JSONB;
              _validation := _validation - 'password';
              PERFORM one_base.event_logger(_validation);
              RAISE sqlstate 'PT409' using
                message = 'Conflict',
                detail = 'adopter duplicate',
                hint = 'You have been here before.';
              -- return _validation;
          WHEN check_violation then
              _validation := '{"status":"406", "msg":"Bad adopter Request, validation error","type":"adopter"}'::JSONB;
              PERFORM one_base.event_logger(_validation);
              RAISE sqlstate 'PT406' using
                message = 'Bad Request',
                detail = 'adopter',
                hint = 'Are you passing correct data?';
          WHEN others then
              _validation := '{"status":"500", "msg":"Unknown adopter insertion error","type":"adopter"}'::JSONB;
              PERFORM one_base.event_logger(_validation);
              RAISE sqlstate 'PT500' using
                message = 'Unidentified',
                detail = 'adopter',
                hint = 'Did not see that comming!';
      END;
    end if;

    return (SELECT row_to_json(r) as result
      from (
        SELECT
        '200' as status,
        'OK' as msg
      ) r
    );
  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.adopter(JSON) to guest_one; -- upsert
grant EXECUTE on FUNCTION one_version_0_0_1.adopter(JSON) to editor_one; -- upsert
*/
-----------------
-- FUNCTION: Create adopter(id TEXT)
-----------------
-- convert ids to lowercase
/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.adopter(id TEXT) RETURNS JSONB
AS $$
  Select form-'password' as adopter from one_base.adopt_a_drain  where pk=id and sk='adopter';
$$ LANGUAGE sql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.adopter(TEXT) to editor_one; -- select
*/

  --=============================================================================
  --=============================================================================
  --=============================================================================
-- Patterns
-- Insert adoptee({"<name>":"<value>","<name>":"<value"} )  ... no id
-- Update adoptee({"id":"<value>",...}) ... id with update values
-- Select adoptee(id TEXT)
-- Delete adoptee({"-id":"<value>"})

  --------------------
  -- FUNCTION: SELECT adoptee(id TEXT)
  --------------------
  /*
  CREATE OR REPLACE FUNCTION one_version_0_0_1.adoptee(id TEXT) RETURNS JSONB
  AS $$
    Select form from one_base.adopt_a_drain  where pk=id and sk='adoptee';
  $$ LANGUAGE sql;

  -- GRANT: Grant Execute
  grant EXECUTE on FUNCTION one_version_0_0_1.adoptee(TEXT) to editor_one;


*/



-----------------
-- FUNCTION: Create adoptee(form JSON)
-----------------
-- Insert {"type":"adoptee", "drain_id":"gr12345667", "lat":42.01, "lon":-84.01}
/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.adoptee(form JSON) RETURNS JSONB
AS $$
  Declare rc jsonb;
  -- Declare _model_user JSONB;
  Declare _form JSONB;
  Declare _jwt_role TEXT;
  Declare _jwt_adoptee TEXT;
  Declare _validation JSONB;
  Declare _adopter_key TEXT;

  BEGIN
    --***** get request values

    _adopter_key := COALESCE(current_setting('request.jwt.claim.key','t'),'8a39dc33-0c6c-4b4e-bdb8-3829af311dd8');
    _jwt_role := COALESCE(current_setting('request.jwt.claim.role','t'),'editor_one');

    --***** check role

    if _jwt_role != 'editor_one' then
      _validation := '{"status":"401", "msg":"Unauthorized Token", "type":"adoptee"}'::JSONB;
      PERFORM one_base.event_logger(_validation);
      RAISE sqlstate 'PT401' using
        message = 'Unauthorized Token',
        detail = 'adoptee',
        hint = format('Not sure what to tell you. Try logging in again. _adopter_key is %s',_adopter_key);
    end if;

	--****** type stamp form and user key

	_form := form::JSONB || format('{"type":"adoptee", "adopter_key":"%s"}', _adopter_key)::JSONB;

	--****** confirm all required attributes are in form

	if not(_form ? 'lat' and _form ? 'lon' and _form ? 'drain_id' and _form ? 'adopter_key' ) then
		 _validation := '{"status":"400","msg":"Bad Request, missing one or more form attributes", "type":"adoptee"}'::JSONB;
		 PERFORM one_base.event_logger(_validation);
		 RAISE sqlstate 'PT400' using
		   message = 'Bad Request',
		   detail = 'adoptee missing attribute(s).',
		   hint = 'Your form is incomplete.';
	end if;

	BEGIN

	   if not(_form ? 'id') then
	       --*****  add ID
	       _form := _form::JSONB || format('{"id":"%s"}', _form ->> 'drain_id' )::JSONB;
	      INSERT INTO one_base.adopt_a_drain
	          (sk, tk, form)
	      VALUES
	          (_form ->> 'drain_id', 'adoptee', _form );
	   else

       if _form ->> 'id' != _form ->> 'drain_id' THEN
              Delete from one_base.adopt_a_drain
                where sk=format('adoptee#%s#%s',_adopter_key,replace(_form ->> 'id','-',''))
                     and tk=_form ->> 'type';
  	   else
    		 UPDATE one_base.adopt_a_drain
    			 set form=(form || _form)
    			 where sk=format('adoptee#%s#%s',_adopter_key,_form ->> 'drain_id')
    			       and tk=_form ->> 'type';

     		 IF NOT FOUND THEN
                  RAISE sqlstate 'PT500' using
                    message = 'Unidentified A',
                    detail = format('adoptee %s - %s',_adopter_key, _form ->> 'drain_id'),
                    hint = 'Did not see that comming!';
    		 END IF;
      end if;
     end if;

	EXCEPTION
	  WHEN unique_violation THEN
	      _validation := '{"status":"409", "msg":"Conflict duplicate adoptee.", "type":"adoptee"}'::JSONB;
	      PERFORM one_base.event_logger(_validation);
	      RAISE sqlstate 'PT409' using
	        message = 'Conflict',
	        detail = 'adoptee duplicate',
	        hint = 'Cannot do this twice!';
	  WHEN check_violation then
	      _validation :=  '{"status":"400", "msg":"Bad adoptee Request, validation error", "type":"adoptee"}'::JSONB;
	      PERFORM one_base.event_logger(_validation);
	      RAISE sqlstate 'PT400' using
	        message = 'Bad Request',
	        detail = 'adoptee',
	        hint = 'Is your data formatted correctly?';
	  WHEN others then
	      _validation :=  format('{"status":"500", "msg":"Unknown adoptee error", "type":"adoptee", "SQLSTATE":"%s"}',SQLSTATE)::JSONB;
	      PERFORM one_base.event_logger(_validation);
	      RAISE sqlstate 'PT500' using
	        message = format('Unidentified Issue'),
	        detail = 'adoptee',
	        hint = format('Did not see that comming!' );
	END;

    return (SELECT row_to_json(r) as result
      from (
        SELECT
        '200' as status,
        'OK' as msg,
        _form as data
      ) r
    );
  END;
$$ LANGUAGE plpgsql;

-- GRANT: Grant Execute adoptee
grant EXECUTE on FUNCTION one_version_0_0_1.adoptee(JSON) to editor_one; -- C

*/
  -----------------
  -- FUNCTION: Delete adoptee(form JSON)
  -----------------



  --=============================================================================
  --=============================================================================
  --=============================================================================


--------------------
-- FUNCTION: Create adoptees(JSON)
--------------------
-- find in boundary
/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.adoptees(bounds JSON) RETURNS TABLE (adoptee jsonb)
AS $$
Declare _validation JSONB;
Declare _bounds JSONB;
BEGIN
  -- JSON is like '{"north": 42.96465175640001,
  --  "south": 42.96065175640001,
  --  "west": -85.6736956307,
  --  "east": -85.6670956307}'
  _bounds := _bounds::JSONB;
  if not(_bounds ? 'west' and _bounds ? 'east' and _bounds ? 'north' and _bounds ? 'south' ) then
     _validation := '{"status":"400","msg":"Bad Request, missing one or more boundary attributes"}'::JSONB;
     PERFORM one_base.event_logger(_validation);
     RAISE sqlstate 'PT400' using
       message = 'Bad Request',
       detail = 'boundary missing attribute(s).',
       hint = 'Your boundary is incomplete.';
  end if;

  return QUERY
      Select to_jsonb(form) from one_base.adopt_a_drain where tk = 'adoptee' and
        CAST (form ->> 'lat' AS DOUBLE PRECISION) < CAST (bounds ->> 'north'  AS DOUBLE PRECISION) and
        CAST (form ->> 'lat' AS DOUBLE PRECISION) > CAST (bounds ->> 'south'  AS DOUBLE PRECISION) and
        CAST (form ->> 'lon' AS DOUBLE PRECISION) > CAST (bounds ->> 'west'  AS DOUBLE PRECISION) and
        CAST (form ->> 'lon' AS DOUBLE PRECISION) < CAST (bounds ->> 'east'  AS DOUBLE PRECISION)
  ;
  -- IF NOT FOUND THEN
  --     RAISE EXCEPTION 'No adoptees in %.', $1;
  -- END IF;

   RETURN;
END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.adoptees(JSON) to editor_one; -- C
grant EXECUTE on FUNCTION one_version_0_0_1.adoptees(JSON) to guest_one; -- C

*/
