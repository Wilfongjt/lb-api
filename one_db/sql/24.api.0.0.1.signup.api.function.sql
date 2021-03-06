\c one_db
CREATE SCHEMA if not exists api_0_0_1;
SET search_path TO api_0_0_1, base_0_0_1, public;

/*
User (TEXT, TEXT, JSON) - INSERT
  _____ _             _    _
 / ____(_)           | |  | |
| (___  _  __ _ _ __ | |  | |_ __
 \___ \| |/ _` | '_ \| |  | | '_ \
 ____) | | (_| | | | | |__| | |_) |
|_____/|_|\__, |_| |_|\____/| .__/
           __/ |            | |
          |___/             |_|

connect (api_authenticator)
          |
          + --->  [signup(TEXT,JSON)]
                      |
switch              (api_guest)
                      |
step                [is_valid_token(guest_token, 'guest')]
                      |
step                [authenticate]
                      |
step                [tokenize credentials]
                      |
switch              (api_authenticator)
                      |
return              {user_token}


INSERT
(api_authenticator)---> signup(token TEXT, form JSON) --> (token.scope) ---> insert(JSON) --> (insertion)
                                 |           |
                  api_token -----+           |
                                             |
                  form {username:"",         |
                        displayname:"",      |
                        password:""} --------+

Insert User  token, {username:<value>,
                     displayname:<value>,
                     password:<value>}

*/
-- INSERT
CREATE OR REPLACE FUNCTION api_0_0_1.signup(token TEXT,form JSON, key TEXT default '0')  RETURNS JSONB AS $$
    Declare _form JSONB; Declare result JSONB; Declare chelate JSONB := '{}'::JSONB;Declare tmp TEXT;

        BEGIN
          -- [Function: Signup given guest_token TEXT, form JSON]
          -- [Description: Add a new user]
          -- [Switch to Role]
          -- [Switch to api_guest Role]
          set role api_guest;

          -- [Validate Token]
          result := base_0_0_1.validate_token(token) ;
          if result is NULL then
            -- [Fail 403 When token is invalid]
            RESET ROLE;
            return format('{"status":"403","msg":"Forbidden","extra":"Invalid token","user":"%s"}',CURRENT_USER)::JSONB;
          end if;

          -- [Verify token has expected scope]
          if not(result ->> 'scope' = 'api_guest') then
              -- [Fail 401 when unexpected scope is detected]
              return '{"status":"401","msg":"Unauthorized"}'::JSONB;
          end if;
          -- [Validate form parameter]
          if form is NULL then
              -- [Fail 400 when form is NULL]
              RESET ROLE;
              return '{"status":"400","msg":"Bad Request"}'::JSONB;
          end if;
          -- [Validate Form with user's credentials]
          _form := form::JSONB;

          -- [Validate Requred form fields]
          if not(_form ? 'username') or not(_form ? 'password') then
              -- [Fail 400 when form is missing requrired field]
              RESET ROLE;
              return '{"status":"400","msg":"Bad Request"}'::JSONB;
          end if;
          -- [Hash password when found]
          if _form ? 'password' then
              --_form := (_chelate ->> 'form')::JSONB;
              _form := _form || format('{"password": "%s"}',crypt(form ->> 'password', gen_salt('bf')) )::JSONB;
          end if;
          -- [Assign Scope]
          _form := _form || format('{"scope":"%s"}','api_user')::JSONB;
          --raise notice 'signup _form %', _form;
          -- [Overide the token's default role]
          set role api_user;

          -- [Assemble Data]
          if CURRENT_USER = 'api_user' then
              if key = '0' then
                  -- [Generate owner key when not provided]
                  chelate := base_0_0_1.chelate('{"pk":"username","sk":"const#USER","tk":"*"}'::JSONB, _form); -- chelate with keys on insert
              else
                if position('#' in key) < 1 then
                    -- [Concat guid to when not 0 and no # is found]
                    key := format('guid#%s',key);
                end if;

                  -- [Overide owner when signup key provided]
                  chelate := base_0_0_1.chelate(format('{"pk":"username","sk":"const#USER","tk":"%s"}', key)::JSONB, _form); -- chelate with keys on insert

              end if;

          end if;

          -- [Stash guid for insert]
          tmp = set_config('request.jwt.claim.key', chelate ->> 'tk', true); -- If is_local is true, the new value will only apply for the current transaction.
          -- [Execute insert]
          chelate := chelate || format('{"owner":"%s"}', chelate ->> 'tk')::JSONB;
          result := base_0_0_1.insert(chelate,chelate ->> 'owner');

          RESET ROLE;
          -- [Return {status,msg,insertion}]
          return result;
        END;
        $$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION api_0_0_1.signup(TEXT,JSON,TEXT) to api_guest;
