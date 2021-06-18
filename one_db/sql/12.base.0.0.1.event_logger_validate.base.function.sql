\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;

-- GRANT: Grant Execute

-----------------
-- FUNCTION: Create event_logger_validate(form JSONB)
-----------------

CREATE OR REPLACE FUNCTION base_0_0_1.event_logger_validate(form JSONB) RETURNS JSONB
AS $$

  BEGIN
    -- [Function: event_logger_validate]
    if not(form ? 'type' ) then
       return '{"status":"400","msg":"Bad Request, event_logger_validate is missing one or more form attributes"}'::JSONB;
    end if;
    if form ? 'password'  then
       return '{"status":"409","msg":"Conflict, password should not be included."}'::JSONB;
    end if;
    return '{"status": "200"}'::JSONB;
  END;
$$ LANGUAGE plpgsql;
-- GRANT: Grant Execute
grant EXECUTE on FUNCTION base_0_0_1.event_logger_validate(JSONB) to event_logger_role; -- upsert
--grant EXECUTE on FUNCTION base_0_0_1.event_logger_validate(JSONB) to editor_one; -- upsert
