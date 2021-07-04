\c one_db
SET search_path TO api_0_0_1, base_0_0_1, public;

-- This is a static file that doesnt get copied


-- POST

CREATE OR REPLACE FUNCTION api_0_0_1.user(token TEXT,form JSON)  RETURNS JSONB AS $$

    Declare _form JSONB;

    Declare result JSONB;

    Declare _chelate JSONB := '{}'::JSONB;

    Declare tmp TEXT;

BEGIN

          -- [Function: User POST]

          -- [Description: Store the original values of a user chelate]

            -- [Parameters: token TEXT,form JSON]

            -- [pk is <text-value> or guid#<value>



          set role api_guest;

          -- [A. Validate token]

          result := base_0_0_1.validate_token(token) ;

          if result is NULL then

            -- [A.1 Fail 403 When token is invalid]

            RESET ROLE;

            return format('{"status":"403","msg":"Forbidden","extra":"Invalid token","user":"%s"}',CURRENT_USER)::JSONB;

          end if;

          -- [B. Verify Parameters]

          -- eg if not(result ->> 'scope' = 'api_admin') and not(result ->> 'scope' = 'api_guest') then

          if not(result ->> 'scope' = 'api_admin') then

              -- [B.1 Fail 401 when unexpected scope is detected]

              RESET ROLE;

              return '{"status":"401","msg":"Unauthorized"}'::JSONB;

          end if;



          if form is NULL then

              -- [B.2 Fail 400 when form is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          _form := form::JSONB;



          if not(_form ? 'username') or not(_form ? 'password') then

              -- [B.3 Fail 400 when form is missing a required field]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



           -- [C. Assemble Chelate Data]

           -- [C.1 Password hash]


                if _form ? 'password' then
                  _form := _form || format('{"password": "%s"}',crypt(form ->> 'password', gen_salt('bf')) )::JSONB;
                end if;




          -- [C.2 User specific code]

          if CURRENT_USER = 'api_admin' then /* custom code */
                _chelate := base_0_0_1.chelate('{"pk":"username","sk":"const#USER","tk":"*"}'::JSONB, _form);
            -- [Stash guid for insert]
            tmp = set_config('request.jwt.claim.key', replace(_chelate ->> 'tk','guid#',''), true);

           end if;



          -- [D. Insert Chelate]

          result := base_0_0_1.insert(_chelate, _chelate ->> 'key');

          RESET ROLE;



          -- [Return {status,msg,insertion}]

          return result;

END;

$$ LANGUAGE plpgsql;

-- POST

grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,JSON) to api_admin;
