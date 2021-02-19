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

ALTER DATABASE one_db SET "app.lb_woden" To :lb_woden;

ALTER DATABASE one_db SET "app.lb_guest_one" To '{"role":"guest_one"}';

ALTER DATABASE one_db SET "app.lb_editor_one" To '{"role":"editor_one", "key":"afoekey012345"}';

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
CREATE TYPE one_version_0_0_1.woden_token AS (
  woden text
);
CREATE TYPE one_version_0_0_1.jwt_token AS (
  token text
);
--=============================================================================
--=============================================================================
--=============================================================================

------------
-- FUNCTION: Create one_version_0_0_1.signin(form JSON)
------------

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

	    RAISE sqlstate 'PT400' using
		       message = 'Bad Request',
		       detail = 'Unhandled criteria combination.',
		       hint = 'try pk & sk or sk & tk or xk & yk.';
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


CREATE OR REPLACE FUNCTION one_version_0_0_1.delete(pkcriteria JSON) RETURNS JSONB
AS $$
  declare cnt INT;
  declare _crit JSONB;
  BEGIN
    BEGIN
      _crit := pkcriteria::JSONB;
      cnt := -3;
      if not(_crit ? 'pk') then
		    RAISE sqlstate 'PT400' using
		        message = 'Missing pk',
		        detail = 'delete',
		        hint = 'Saw that comming!';
      end if;
      cnt := -2;
      if not(_crit ? 'sk') then
	    RAISE sqlstate 'PT400' using
	        message = 'Missing sk',
	        detail = 'delete',
	        hint = 'Saw that comming!';
      end if;
      cnt := -1;
      Select count(*) into cnt
        from one_base.one
        where pk=_crit ->> 'pk' and sk=_crit ->> 'sk';

      Delete from one_base.one
        where pk=_crit ->> 'pk' and sk=_crit ->> 'sk';

	  return (SELECT to_jsonb(r) as result
	    from (
	      SELECT
	      200 as status,
	      'OK' as msg,
	      cnt as count
	    ) r
	  );

    EXCEPTION

    	when others then
    	 	 return (SELECT to_jsonb(r) as result
					    from (
					      SELECT
					      400 as status,
					      'Bad Request' as msg,
					      cnt as count,
					      pkcriteria as criteria
					    ) r
					  );

    END;

  END;
$$ LANGUAGE plpgsql;

-- GRANT: Grant Execute
grant EXECUTE on FUNCTION one_version_0_0_1.delete(JSON) to editor_one;


CREATE OR REPLACE FUNCTION one_version_0_0_1.insert(chelate JSON) RETURNS JSONB
AS $$
  declare _chelate JSONB;
BEGIN

	BEGIN
    _chelate := chelate::JSONB;
    -- verify token (is valid, is guest)
    /*
    if not(one_base.is_valid_token(_token, 'guest')) then
      RAISE sqlstate 'PT400' using
       message = 'Bad Request',
       detail = 'missing attribute(s).',
       hint = 'Your insert is incomplete.';
    end if;
    */
    -- must have pk sk tk and form
    if not(_chelate ? 'pk' and _chelate ? 'sk' and _chelate ? 'tk' and _chelate ? 'form') then
      RAISE sqlstate 'PT400' using
       message = 'Bad Request',
       detail = 'missing attribute(s).',
       hint = 'Your insert is incomplete.';
    ene if;
    -- insert
    insert into one_base.one (pk,sk,tk,form)
      values (_chelate ->> 'pk',
              _chelate ->> 'sk',
              _chelate ->> 'tk',
              _chelate ->> 'form');

  EXCEPTION
    	when others then
    	  return QUERY
			select to_jsonb('{"status":"400", "msg":"Bad Request"}'::JSON) ;
	END;

END;
$$ LANGUAGE plpgsql;
grant EXECUTE on FUNCTION one_version_0_0_1.insert(JSON) to editor_one;





/*
CREATE OR REPLACE FUNCTION one_version_0_0_1.signin(form JSON) RETURNS JSONB
AS $$
  -- make token to execute app(JSON)
  declare rc JSONB;
  declare signin_token TEXT;
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

    -- make signin_token
    SELECT public.sign(
      row_to_json(r), current_setting('app.settings.jwt_secret')
    ) AS woden into signin_token
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
    _validation := _form || '{"status":200}'::JSONB;

    PERFORM one_base.event_logger(_validation);
    -- test for owner account
    -- wrap signin_token in JSON
    return (SELECT row_to_json(r) as result
      from (
        SELECT
        signin_token as token
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
        200 as status,
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
        200 as status,
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
