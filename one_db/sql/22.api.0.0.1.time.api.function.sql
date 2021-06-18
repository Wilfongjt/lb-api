\c one_db
SET search_path TO api_0_0_1, base_0_0_1, public;

--=============================================================================
-- TIME
--=============================================================================

/*
 _______ _
|__   __(_)
   | |   _ _ __ ___   ___
   | |  | | '_ ` _ \ / _ \
   | |  | | | | | | |  __/
   |_|  |_|_| |_| |_|\___|



*/


CREATE OR REPLACE FUNCTION api_0_0_1.time() RETURNS JSONB
AS $$
  declare _time timestamp;
  declare _zone TEXT;
BEGIN
  SELECT NOW()::timestamp into _time ;
  SELECT current_setting('TIMEZONE') into _zone;
  return format('{"status":"200", "msg":"OK", "time": "%s", "zone":"%s"}',_time,_zone)::JSONB;
END;
$$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION api_0_0_1.time() to api_guest;
grant EXECUTE on FUNCTION api_0_0_1.time() to api_user;
