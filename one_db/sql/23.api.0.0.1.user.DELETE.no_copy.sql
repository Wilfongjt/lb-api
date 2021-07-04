\c one_db
SET search_path TO api_0_0_1, base_0_0_1, public;

-- This is a static file that doesnt get copied
-- DELETE



CREATE OR REPLACE FUNCTION api_0_0_1.user(token TEXT,pk TEXT) RETURNS JSONB AS $$

    Declare result JSONB;

    Declare _form JSONB := '{}'::JSONB;

BEGIN

          -- [Function: user DELETE]

          -- [Description: remove item by primary key ]

          -- [Parameters: token TEXT,pk TEXT]



          set role api_guest;



          -- [A. Validate Token]

          result := base_0_0_1.validate_token(token) ;

          if result is NULL then

            -- [A.1 Fail 403 When token is invalid]

            RESET ROLE;

            return format('{"status":"403","msg":"Forbidden","extra":"Invalid token","user":"%s"}',CURRENT_USER)::JSONB;

          end if;



          -- [B. Validate Parameters]

          -- eg if not(result ->> 'scope' = 'api_admin') and not(result ->> 'scope' = 'api_guest') then

          if not(result ->> 'scope' = 'api_user') and not(result ->> 'scope' = 'api_admin') then

              -- [B.1 Fail 401 when unexpected token scope is detected]

              RESET ROLE;

              return '{"status":"401","msg":"Unauthorized"}'::JSONB;

          end if;



          if pk is NULL then

              -- [B.2 Fail 400 when pk is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          -- [C. Assemble Chelate Data]



          if CURRENT_USER = 'api_user' then /* custom code */
                    if strpos(pk,'#') > 0 then
                    -- [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
                    -- [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]
                    _form := format('{"pk":"%s", "sk":"const#USER"}',pk)::JSONB;
                else
                    -- [Wrap pk as primary key when # is not found in pk]
                    -- [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
                    _form := format('{"pk":"username#%s", "sk":"const#USER"}',pk)::JSONB;
                end if;
            elsif CURRENT_USER = 'api_admin' then /* custom code */
                    if strpos(pk,'#') > 0 then
                    -- [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
                    -- [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]
                    _form := format('{"pk":"%s", "sk":"const#USER"}',pk)::JSONB;
                else
                    -- [Wrap pk as primary key when # is not found in pk]
                    -- [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
                    _form := format('{"pk":"username#%s", "sk":"const#USER"}',pk)::JSONB;
                end if;

           end if;



          -- [D. Delete Chelate]

          result := base_0_0_1.delete(_form, result ->> 'key');

          RESET ROLE;



          -- [Return {status,msg,deletion}]

          return result;

END;

$$ LANGUAGE plpgsql;

-- DELETE

-- e.g., grant EXECUTE on FUNCTION

grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,TEXT) to api_user;
grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,TEXT) to api_admin;
