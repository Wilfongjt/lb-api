\c one_db
SET search_path TO api_0_0_1, base_0_0_1, public;

-- This is a static file that doesnt get copied

-- GET



CREATE OR REPLACE FUNCTION api_0_0_1.user(token TEXT, form JSON, options JSON) RETURNS JSONB AS $$

    Declare _form JSONB;

    Declare result JSONB;

BEGIN

          -- [Function: User GET]

          -- [Description: Find the values of a user chelate]

          -- [Parameters: token TEXT,form JSON,options JSON]



          set role api_guest;



          -- [A. Validate Token]

          result := base_0_0_1.validate_token(token) ;

          if result is NULL then

            -- [A.1 Fail 403 When token is invalid]

            RESET ROLE;

            return format('{"status":"403","msg":"Forbidden","extra":"Invalid token","user":"%s"}',CURRENT_USER)::JSONB;

          end if;



          -- [B. Verify Parameters]

          -- eg if not(result ->> 'scope' = 'api_admin') and not(result ->> 'scope' = 'api_guest') then

          if not(result ->> 'scope' = 'api_user') and not(result ->> 'scope' = 'api_admin') then

              RESET ROLE;

              -- [B.1 Fail 401 when unexpected scope is detected]

              return '{"status":"401","msg":"Unauthorized"}'::JSONB;

          end if;



          if form is NULL then

              -- [B.2 Fail 400 when form is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          _form := form::JSONB;



          if _form ? 'pk' and _form ? 'sk' then

               -- [B.3Primary query {pk,sk}]

               _form = format('{"pk":"%s", "sk":"%s"}',_form ->> 'pk',_form ->> 'sk')::JSONB;

          elsif _form ? 'pk' and not(_form ? 'sk') then

               -- [B.4 Primary query {pk,sk:*}]

               _form = format('{"pk":"%s", "sk":"%s"}',_form ->> 'pk','*')::JSONB;

          elsif _form ? 'sk' and _form ? 'tk' then

               -- [B.5 Secondary query {sk,tk}]

               _form = format('{"sk":"%s", "tk":"%s"}',_form ->> 'sk',_form ->> 'tk')::JSONB;

          elsif _form ? 'sk' and not(_form ? 'tk') then

               -- [B.6 Secondary query {sk,tk:*}]

               _form = format('{"sk":"%s", "tk":"%s"}',_form ->> 'sk','*')::JSONB;

          elsif _form ? 'xk' and _form ? 'yk' then

               -- [B.7 Teriary query {tk,sk} aka {xk, yk}]

               _form = format('{"xk":"%s", "yk":"%s"}',_form ->> 'xk',_form ->> 'yk')::JSONB;

          elsif _form ? 'xk' and not(_form ? 'yk') then

               -- [B.8 Teriary query {tk} aka {xk}]

               _form = format('{"xk":"%s", "yk":"%s"}',_form ->> 'xk','*')::JSONB;

          elsif _form ? 'yk' and _form ? 'zk' then

               -- [B.9 Quaternary query {sk,pk} akd {yk,zk}

               _form = format('{"yk":"%s", "zk":"%s"}',_form ->> 'yk',_form ->> 'zk')::JSONB;

          elsif _form ? 'yk' and not(_form ? 'zk') then

               -- [B.10 Quaternary query {yk}

               _form = format('{"yk":"%s", "zk":"%s"}',_form ->> 'yk','*')::JSONB;

          else

              -- [B.11 Fail 400 when form is NULL]

              RESET ROLE;

              return '{"status":"400","msg":"Bad Request"}'::JSONB;

          end if;



          -- [C. Assemble Chelate Data]



          if CURRENT_USER = 'api_user' then /* custom code */
                    -- no custom code
            elsif CURRENT_USER = 'api_admin' then /* custom code */
                    -- no custom code

           end if;



          -- [D. Query Chelate]

          result := base_0_0_1.query(_form);

          RESET ROLE;

          -- [Return {status,msg,selection}]

          return result;

END;

$$ LANGUAGE plpgsql;

-- GET

-- e.g., grant EXECUTE on FUNCTION

grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,JSON,JSON) to api_user;
grant EXECUTE on FUNCTION api_0_0_1.user(TEXT,JSON,JSON) to api_admin;
