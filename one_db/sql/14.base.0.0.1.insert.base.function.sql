\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;


--=============================================================================
-- INSERT
--=============================================================================
-- returns {}

-- Insert
--  _____                     _
-- |_   _|                   | |
--   | |  _ __  ___  ___ _ __| |_
--   | | | '_ \/ __|/ _ \ '__| __|
-- _ | |_| | | \__ \  __/ |  | |_
-- |_____|_| |_|___/\___|_|   \__|
-- {pk, sk, tk}
-- {pk, sk}
-- {sk, tk}

-- todo: add user id to inserted record ... :""
-- insert
--

CREATE OR REPLACE FUNCTION base_0_0_1.insert(_chelate JSONB,key TEXT) RETURNS JSONB
AS $$
  --declare _chelate JSONB;
  declare _form JSONB;
  declare _result record;
  declare _extra TEXT;
  --declare _scope TEXT; -- soft role
  --declare key TEXT; -- who is inserting this record
BEGIN
  -- [Function: Insert Chelate like {pk,sk,tk,form}, {pk,sk,form}, {sk,tk,form}, or {sk,form}]
  -- [Validate Chelate]
  if _chelate is NULL then
    -- [Fail 400 when a parameter is NULL]
    return '{"status":"400","msg":"Bad Request"}'::JSONB;
  end if;
  BEGIN
      --_scope := COALESCE(current_setting('request.jwt.claim.scope','t'), 'guest');
      -- [Add owner to chelate]
      -- key := COALESCE(current_setting('request.jwt.claim.key','t'), current_user);
      -- set_config('request.jwt.claim.key',guid); -- with a guid# prefix
      -- key := COALESCE(current_setting('request.jwt.claim.key','t'), '0');
      --raise notice 'insert request.jwt.claim.key %',current_setting('request.jwt.claim.key','t');
      -- [figure out who the owner is]
      --key := COALESCE(current_setting('request.jwt.claim.key','t'), '0');
      key := COALESCE(key, '0');

      --Raise Notice 'owner %', key;

      _form := (_chelate ->> 'form')::JSONB;
      --_form := _form || format('{"owner":"%s"}',key)::JSONB;
    	  -- insert
      -- !form
      if key = '0' then
        -- [Insert requires an owner key value]
        return '{"status":"400", "msg":"Bad Request", "extra":"chelate is missing owner."}'::JSONB;
      end if;
      if not(_chelate ? 'form') then -- MISSING FORM
        -- [Fail 400 when chelate is missig a form]
        return '{"status":"400", "msg":"Bad Request", "extra":"chelate is missing form."}'::JSONB;
      end if;
      -- pksktk
      -- [Insert Unique Chelate]
      if _chelate ? 'pk' and _chelate ? 'sk' and _chelate ? 'tk' then
        -- [Handle chelate with pk, sk and tk]
        _extra := 'A';
        insert into base_0_0_1.one (pk,sk,tk,form,owner)
          values (lower(_chelate ->> 'pk'), (_chelate ->> 'sk'), (_chelate ->> 'tk'), _form, key)
          returning * into _result;
        --raise notice 'A insert form %',_form;
      -- pksk
      elsif _chelate ? 'pk' and _chelate ? 'sk' then
        -- [Handle chelate with pk and sk]
        _extra := 'B';
        insert into base_0_0_1.one (pk,sk,form,owner)
          values (lower(_chelate ->> 'pk'), (_chelate ->> 'sk') ,_form, key)
          returning * into _result;
        --raise notice 'B insert form %',_form;

      -- sktk
      elsif _chelate ? 'sk' and _chelate ? 'tk' then
        -- [Handle chelate with sk and tk]
        _extra := 'C';
        insert into base_0_0_1.one (sk,tk,form,owner)
          values ((_chelate ->> 'sk'), (_chelate ->> 'tk') ,_form, key)
          returning * into _result;
        --raise notice 'C insert form %',_form;

      -- sk
      elsif _chelate ? 'sk' then
        -- [Handle chelate with sk]
        _extra := 'D';
        insert into base_0_0_1.one (sk,form,owner)
          values (
                  (_chelate ->> 'sk'),
                  _form, key) returning * into _result;
        --raise notice 'D insert form %',_form;

      else
        -- [Fail 400 when chelate is missing a proper set of keys (pk,sk,tk),(pk,sk),(sk,tk), or (sk)]
        return '{"status":"400", "msg":"Bad Request", "extra":"failed insert"}'::JSONB;
      end if;
          --raise notice 'insert 3';

    EXCEPTION
         -- when sqlstate 'PT400' then
         --   return '{"status":"400", "msg":"Bad Request"}'::JSONB;
          when unique_violation then
            -- [Fail 409 when duplicate]
            return '{"status":"409", "msg":"Duplicate"}'::JSONB;
          when others then
            RAISE NOTICE 'Insert Beyond here there be dragons! %', sqlstate;
            return format('{"status":"%s", "msg":"Unhandled","extra":"%s","owner":"%s","chelate":%s}', sqlstate, _extra,key,_chelate)::JSONB;
    END;
    -- [Return {status,msg,insertion}]
    --raise notice '[Remove the password from Insert response!]';
    return format('{"status":"200", "msg":"OK", "insertion": %s}',(to_jsonb(_result)#- '{form,password}')::TEXT)::JSONB;
    --return format('{"status":"200", "msg":"OK", "insertion": %s}',to_jsonb(_result)::TEXT)::JSONB;

END;
$$ LANGUAGE plpgsql;

--grant EXECUTE on FUNCTION base_0_0_1.insert(JSONB) to api_guest;
grant EXECUTE on FUNCTION base_0_0_1.insert(JSONB,TEXT) to api_user;
