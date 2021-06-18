\c one_db

SET search_path TO base_0_0_1, public;



CREATE OR REPLACE FUNCTION base_0_0_1.validate_credentials(credentials JSONB) RETURNS JSONB
      AS $$
      BEGIN
        -- [Function: Validate Credentials given Credentials like {username,password}]
        -- username
        -- displayname
        -- password
        if credentials is NULL then
          -- [Exit NULL when credentials are NULL]
        	return NULL;
        end if ;
        if not(credentials ? 'username')
            or not(credentials ? 'password')
        then
          -- [Exit NULL when username or password is missing]
          return NULL;
        end if;
        -- [Return Credentials on success]
        return credentials;
      END;
    $$ LANGUAGE plpgsql;

    grant EXECUTE on FUNCTION base_0_0_1.validate_credentials(JSONB) to api_user;
--    grant EXECUTE on FUNCTION base_0_0_1.validate_credentials(JSONB) to api_guest;
