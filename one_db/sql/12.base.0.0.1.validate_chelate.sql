\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;
CREATE OR REPLACE FUNCTION base_0_0_1.validate_chelate(chelate JSONB, expected TEXT) RETURNS JSONB
    AS $$
      Declare state TEXT;
    BEGIN
      -- [Function: Validate Chelate given Chelate and Expected Value]
      -- On Sucess, return
      -- On Failure, return reason
      if chelate is NULL or expected is NULL then
        -- [False when Chelate or Expected is NULL]
        return NULL;
      end if;
      -- [Check for existance of pk,sk,tk,form,owner,active,created, and updated]
      state := '';
      if chelate ? 'pk' then state := state ||'P'::TEXT; else state := state || 'p'; end if;
      if chelate ? 'sk' then state := state || 'S'; else state := state || 's'; end if;
      if chelate ? 'tk' then state := state || 'T'; else state := state || 't'; end if;
      if chelate ? 'form' then state := state || 'F'; else state := state || 'f'; end if;
      if chelate ? 'owner' then state := state || 'O';  else state := state || 'o'; end if;
      if chelate ? 'active' then state := state || 'A'; else state := state || 'a'; end if;
      if chelate ? 'created' then state := state || 'C'; else state := state || 'c'; end if;
      if chelate ? 'updated' then state := state || 'U'; else state := state || 'u'; end if;

      if not(state = expected) then
        -- [Exit with NULL when evaluation does not match expected]
        return NULL;
      end if;
      -- [Return chelate when evaluation matches expected]
  	  return chelate;
    END;
  $$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.validate_chelate(JSONB, TEXT) to api_guest;
grant EXECUTE on FUNCTION base_0_0_1.validate_chelate(JSONB, TEXT) to api_user;
