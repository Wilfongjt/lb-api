\c one_db

SET search_path TO base_0_0_1, public;

CREATE OR REPLACE FUNCTION base_0_0_1.validate_token(_token TEXT) RETURNS JSONB
  AS $$

    DECLARE valid_user JSONB;
    DECLARE tx TEXT;

  BEGIN
    -- [Function: Validate Token]
    -- [Description: Validate Token given token and expected scope]
    -- is token null
    -- does role in token match expected role
    -- use db parameter app.settings.jwt_secret
    -- event the token
    -- return true/false
    --raise notice 'is_valid_token %',_token;
    if _token is NULL then
      -- [False when token or scope is NULL]
      return NULL;
    end if;

    BEGIN

	    valid_user := to_jsonb(verify(_token,current_setting('app.settings.jwt_secret'),'HS256' ))::JSONB;

      if not((valid_user ->> 'valid')::BOOLEAN) then
        return NULL;
      end if;

      valid_user := (valid_user ->> 'payload')::JSONB;

      -- [Ensure token payload has user and scope claims]
      if not(valid_user ? 'scope') or not(valid_user ? 'user')  then
      	return NULL;
      end if;

      -- [Set user in session]
      -- [Set scope in session]
      -- [Set user key in session]
      tx := set_config('request.jwt.claim.user', valid_user ->> 'user', true); -- If is_local is true, the new value will only apply for the current transaction.
      tx := set_config('request.jwt.claim.scope', valid_user ->> 'scope', true); -- If is_local is true, the new value will only apply for the current transaction.
      tx := set_config('request.jwt.claim.key', valid_user ->> 'key', true); -- If is_local is true, the new value will only apply for the current transaction.
      -- [Set role to token scope]
      Execute(format('set role %s',(valid_user ->> 'scope')));

    EXCEPTION
        when sqlstate '22021' then
          RAISE NOTICE 'character_not_in_repertoire sqlstate %', sqlstate;
          RETURN NULL;
        when others then
          RAISE NOTICE 'validate_token has unhandled sqlstate %', sqlstate;
          RETURN NULL;
    END;
    -- [False when scope isnt verified]

    -- [Return token claims]
    RETURN valid_user;
  END;  $$ LANGUAGE plpgsql;

  grant EXECUTE on FUNCTION base_0_0_1.validate_token(TEXT) to api_guest;

  --grant EXECUTE on FUNCTION base_0_0_1.validate_token(TEXT,TEXT) to api_user;
/*
CREATE OR REPLACE FUNCTION base_0_0_1.validate_token(_token TEXT,expected TEXT) RETURNS JSONB
  AS $$

    DECLARE valid_user JSONB;
    DECLARE tx TEXT;

  BEGIN
    -- Validate Token]
    -- Description: Validate Token given token and expected scope]
    -- is token null
    -- does role in token match expected role
    -- use db parameter app.settings.jwt_secret
    -- event the token
    -- return true/false
    --raise notice 'is_valid_token %',_token;
    if _token is NULL then
      -- False when token or scope is NULL]
      return NULL;
    end if;

    BEGIN

	    valid_user := to_jsonb(verify(_token,current_setting('app.settings.jwt_secret'),'HS256' ))::JSONB;

      if not((valid_user ->> 'valid')::BOOLEAN) then
        return NULL;
      end if;

      valid_user := (valid_user ->> 'payload')::JSONB;

      -- Ensure token payload has user and scope claims]
      if not(valid_user ? 'scope') or not(valid_user ? 'user')  then
      	return NULL;
      end if;


      -- Set user in session]
      -- Set scope in session]
      -- Set user key in session]
      tx := set_config('request.jwt.claim.user', valid_user ->> 'user', true); -- If is_local is true, the new value will only apply for the current transaction.
      tx := set_config('request.jwt.claim.scope', valid_user ->> 'scope', true); -- If is_local is true, the new value will only apply for the current transaction.
      tx := set_config('request.jwt.claim.key', valid_user ->> 'key', true); -- If is_local is true, the new value will only apply for the current transaction.
      -- Set role to token scope]
      Execute(format('set role %s',(valid_user ->> 'scope')));

    EXCEPTION
        when sqlstate '22021' then
          RAISE NOTICE 'character_not_in_repertoire sqlstate %', sqlstate;
          RETURN NULL;
        when others then
          RAISE NOTICE 'validate_token has unhandled sqlstate %', sqlstate;
          RETURN NULL;
    END;
    -- False when scope isnt verified]

    -- Return token claims]
    RETURN valid_user;
  END;  $$ LANGUAGE plpgsql;

  grant EXECUTE on FUNCTION base_0_0_1.validate_token(TEXT,TEXT) to api_guest;


*/
