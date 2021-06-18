\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;


--=============================================================================
-- DELETE
--=============================================================================


-- Delete
--  _____       _      _
-- |  __ \     | |    | |
-- | |  | | ___| | ___| |_ ___
-- | |  | |/ _ \ |/ _ \ __/ _ \
-- | |__| |  __/ |  __/ ||  __/
-- |_____/ \___|_|\___|\__\___|

-- {pk,sk}
-- ToDo: limit delete to users personal records.

CREATE OR REPLACE FUNCTION base_0_0_1.delete(criteria JSONB, owner_ TEXT) RETURNS JSONB
AS $$
  --declare _crit JSONB;
  declare _result record;
  declare _status TEXT;
  declare _msg TEXT;
  declare _rc JSONB;
  BEGIN
    -- [Function: Delete by Primary Criteria {pk,sk}]
    -- [Description: Delete User by primary key {pk,sk}]
    -- [Validate Criteria]
      criteria := base_0_0_1.validate_criteria(criteria);

      if criteria is NULL then
      -- [Fail 400 when a criteria parameter is NULL]
        return '{"status":"400","msg":"Bad Request"}'::JSONB;
      end if;

      --if not(criteria ? 'pk') or  not(criteria ? 'sk') then -- {pk sk}
      --  -- [Fail 400 when criteria is missing pk or sk]
      --  return format('{"status":"400", "msg":"Bad Request", "criteria":%s}',criteria)::JSONB ;
      --end if;

      BEGIN
          --_crit := criteria::JSONB;
          -- there can be only one
          if criteria ? 'pk' and criteria ? 'sk' and criteria ->> 'sk' = '*' then

              -- [Delete where pk and sk]
              Delete from base_0_0_1.one
                where lower(pk)=lower(criteria ->> 'pk') and owner=owner_
                returning * into _result;

          elsif criteria ? 'pk' and criteria ? 'sk' then

            -- [Delete where pk and sk]
              Delete from base_0_0_1.one
                where lower(pk)=lower(criteria ->> 'pk')
                      and sk=criteria ->> 'sk'
                      and owner=owner_
                returning * into _result;

          elsif criteria ? 'sk' and criteria ? 'tk' then

            Delete from base_0_0_1.one
              where sk=criteria ->> 'sk' and tk=criteria ->> 'tk'
              and owner=owner_
              returning * into _result;
          else

              return format('{"status":"400", "msg":"Bad Request", "criteria":%s}',criteria)::JSONB ;
          end if;
          -- [Remove password from results when found]

          _rc :=  to_jsonb(_result)  #- '{form,password}';

          if _rc ->> 'pk' is NULL then
            -- [Fail 404 when primary key is not found]
            -- [Fail 404 when item is not owned by current]
            return format('{"status":"404", "msg":"Not Found", "owner":"%s", "criteria":%s}', owner_, criteria)::JSONB ;
          end if;

      EXCEPTION

          when others then
            RAISE NOTICE '5 Beyond here there be dragons! %', sqlstate;
            return format('{"status":"%s", "msg":"Internal Server Error", "criteria":%s}',sqlstate,criteria)::JSONB ;
      END;

      -- [Return {status,msg,criteria,deletion}]
      return format('{"status":"200", "msg":"OK", "criteria":%s, "deletion":%s}',criteria,_rc::TEXT)::JSONB ;
  END;
  $$ LANGUAGE plpgsql;

-- GRANT: Grant Execute

grant EXECUTE on FUNCTION base_0_0_1.delete(JSONB,TEXT) to api_user;
