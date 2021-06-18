\c one_db

SET search_path TO base_0_0_1, public;

CREATE OR REPLACE FUNCTION base_0_0_1.is_valid_token(_token TEXT, expected_role TEXT) RETURNS BOOLEAN
  AS $$

    DECLARE good Boolean;
    DECLARE tx TEXT;
    DECLARE valid_user JSONB;

  BEGIN
    -- [Function: Validate Token given token and expected scope]
    -- is token null
    -- does role in token match expected role
    -- use db parameter app.settings.jwt_secret
    -- event the token
    -- return true/false
    --raise notice 'is_valid_token %',_token;
    if _token is NULL
      or expected_role is NULL
    then
      -- [False when token or scope is NULL]
      return false;
    end if;

    good:=false;
    BEGIN
     --raise notice '_token %', _token;
     --raise notice 'current user %', current_user;
     -- [Remove Bearer prefix on token]
     _token := replace(_token,'Bearer ','');
	   valid_user := to_jsonb(verify(_token,current_setting('app.settings.jwt_secret'),'HS256' ))::JSONB;

    EXCEPTION
      when sqlstate '22021' then
        RAISE NOTICE 'character_not_in_repertoire sqlstate %', sqlstate;
        RETURN false;
      when others then
        RAISE NOTICE 'is_valid_token has unhandled sqlstate %', sqlstate;
        RETURN false;
    END;
    -- [False when scope isnt verified]
    -- [Scope may contain more than one comma delemeted role]
    if strpos((valid_user ->> 'payload')::JSONB ->> 'scope', expected_role) > 0 then
    --if (valid_user ->> 'payload')::JSONB ->> 'scope' = expected_role then
      good := true;
        -- [Set user in session]
        -- [Set scope in session]
        -- [Set user key in session]
        tx := set_config('request.jwt.claim.user', (valid_user ->> 'payload')::JSONB ->> 'user', true); -- If is_local is true, the new value will only apply for the current transaction.
        tx := set_config('request.jwt.claim.scope', (valid_user ->> 'payload')::JSONB ->> 'scope', true); -- If is_local is true, the new value will only apply for the current transaction.
        tx := set_config('request.jwt.claim.key', (valid_user ->> 'payload')::JSONB ->> 'key', true); -- If is_local is true, the new value will only apply for the current transaction.
    end if;
    -- [Return Boolean]
    RETURN good;
  END;  $$ LANGUAGE plpgsql;

  grant EXECUTE on FUNCTION base_0_0_1.is_valid_token(TEXT, TEXT) to api_guest;
  grant EXECUTE on FUNCTION base_0_0_1.is_valid_token(TEXT, TEXT) to api_user;
  grant EXECUTE on FUNCTION base_0_0_1.is_valid_token(TEXT, TEXT) to api_admin;
