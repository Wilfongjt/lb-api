\c one_db

SET search_path TO api_0_0_1, base_0_0_1, public;

-- This is a static file that doesnt get copied

-- PUT



CREATE OR REPLACE FUNCTION api_0_0_1.user(token TEXT,pk TEXT,form JSON) RETURNS JSONB AS $$

    Declare _chelate JSONB := '{}'::JSONB;

    Declare _criteria JSONB := '{}'::JSONB;

    Declare _form JSONB := '{}'::JSONB;

    Declare result JSONB;



BEGIN

          -- [Function: User PUT]

          -- [Description: Change form keys. Pk, sk, tk will change when related form key change]

          -- [Parameters: token TEXT,pk JSON, form JSON]



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

          if not(result ->> 'scope' = 'api_user') and not(result ->> 'scope' = 'api_admin') then

              -- [B.1 Fail 401 when unexpected scope is detected]

              RESET ROLE;

              return '{"status":"401","msg":"Unauthorized"}'::JSONB;

          end if;



          if pk is NULL then

              -- [B.2 Fail 400 when pk is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          if form is NULL then

              -- [B.3 Fail 400 when form is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          _form := form::JSONB;



          -- [C. Assemble Chelate Data]



          -- [C.1 Password hash]


                if _form ? 'password' then
                  _form := _form || format('{"password": "%s"}',crypt(form ->> 'password', gen_salt('bf')) )::JSONB;
                end if;




          -- [C.2 User specific code]

          if CURRENT_USER = 'api_user' then /* custom code */
                if strpos(pk,'#') > 0 then
              -- [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
              -- [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]
              _criteria := format('{"pk":"%s", "sk":"const#USER"}',pk)::JSONB;
            else
              -- [Wrap pk as primary key when # is not found in pk]
              -- [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
              _criteria := format('{"pk":"username#%s", "sk":"const#USER"}',pk)::JSONB;
            end if;
            -- merget pk and sk
            _chelate := _chelate || _criteria;
            -- add the provided form
            _chelate := _chelate || format('{"form": %s}',_form)::JSONB;
            elsif CURRENT_USER = 'api_admin' then /* custom code */
                if strpos(pk,'#') > 0 then
              -- [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
              -- [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]
              _criteria := format('{"pk":"%s", "sk":"const#USER"}',pk)::JSONB;
            else
              -- [Wrap pk as primary key when # is not found in pk]
              -- [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
              _criteria := format('{"pk":"username#%s", "sk":"const#USER"}',pk)::JSONB;
            end if;
            -- merget pk and sk
            _chelate := _chelate || _criteria;
            -- add the provided form
            _chelate := _chelate || format('{"form": %s}',_form)::JSONB;

           end if;



          -- [D. Update Chelate with key]

          result := base_0_0_1.update(_chelate, result ->> 'key');

          RESET ROLE;



          -- [Return {status,msg,updation}]

          return result;

END;

$$ LANGUAGE plpgsql;

-- PUT

-- e.g., grant EXECUTE on FUNCTION

grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,TEXT,JSON) to api_user;
grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,TEXT,JSON) to api_admin;
