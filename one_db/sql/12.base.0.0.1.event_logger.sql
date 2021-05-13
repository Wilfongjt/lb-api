\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;


/*
 ______               _     _
|  ____|             | |   | |
| |____   _____ _ __ | |_  | |     ___   __ _  __ _  ___ _ __
|  __\ \ / / _ \ '_ \| __| | |    / _ \ / _` |/ _` |/ _ \ '__|
| |___\ V /  __/ | | | |_  | |___| (_) | (_| | (_| |  __/ |
|______\_/ \___|_| |_|\__| |______\___/ \__, |\__, |\___|_|
                                        __/ | __/ |
                                       |___/ |___/


*/

-----------------
-- FUNCTION: Create event_logger(_form JSONB)
-----------------

CREATE OR REPLACE FUNCTION base_0_0_1.event_logger(form JSONB) RETURNS JSONB
AS $$
  Declare rc jsonb;
  Declare _model_user JSONB;
  Declare _form JSONB;
  Declare _jwt_role TEXT;
  Declare _validation JSONB;
  Declare _password TEXT;

  BEGIN
    -- [Function: event_logger]
    _form := form;
    _validation := base_0_0_1.event_logger_validate(_form);
    if _validation ->> 'status' != '200' then
        return _validation;
    end if;

    if _form ? 'id' then
        return '{"status": "400", "msg": "Update not supported"}'::JSONB;
    else

      BEGIN
              INSERT INTO base_0_0_1.one
                  (sk, tk, form)
              VALUES
                  ('event',_form ->> 'type', _form);
      EXCEPTION
          WHEN unique_violation THEN
              return '{"status":"400", "msg":"Bad event Request, duplicate error"}'::JSONB;
          WHEN check_violation then
              return '{"status":"400", "msg":"Bad event Request, validation error"}'::JSONB;
          WHEN others then
              return format('{"status":"500", "msg":"Unknown event insertion error", "SQLSTATE":"%s"}',SQLSTATE)::JSONB;
      END;
    end if;

    rc := '{"msg": "OK", "status": "200"}'::JSONB;
    return rc;
  END;
$$ LANGUAGE plpgsql;
