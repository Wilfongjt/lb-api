\c one_db;

SET search_path TO api_0_0_1,  base_0_0_1, public;



/*
                      _      _
                     | |    | |
  _____   _____ _ __ | |_   | | ___   __ _  __ _  ___ _ __
 / _ \ \ / / _ \ '_ \| __|  | |/ _ \ / _` |/ _` |/ _ \ '__|
|  __/\ V /  __/ | | | |_   | | (_) | (_| | (_| |  __/ |
 \___| \_/ \___|_| |_|\__|  |_|\___/ \__, |\__, |\___|_|
                                      __/ | __/ |
                                     |___/ |___/


*/
--------------------
-- EVENT_LOGGER Tests
--------------------
BEGIN;

  SELECT plan(2);
  -- TEST: Test event_logger Insert
  -- 1 Event logger
  SELECT has_function(
      'base_0_0_1',
      'event_logger',
      ARRAY[ 'JSONB' ],
      'Function Event_Logger Insert (jsonb) exists'
  );
  SELECT is (
    base_0_0_1.event_logger(
      '{
      "type":"test",
      "name":"some stuff",
      "desc":"more stuff"
      }'::JSONB
    ),
    '{"msg": "OK", "status": "200"}'::JSONB,
    'Event_Logger - insert test  0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
