\c one_db;

SET search_path TO base_0_0_1, public;

/*
__      __   _ _     _       _          _____              _            _   _       _
\ \    / /  | (_)   | |     | |        / ____|            | |          | | (_)     | |
 \ \  / /_ _| |_  __| | __ _| |_ ___  | |     _ __ ___  __| | ___ _ __ | |_ _  __ _| |___
  \ \/ / _` | | |/ _` |/ _` | __/ _ \ | |    | '__/ _ \/ _` |/ _ \ '_ \| __| |/ _` | / __|
   \  / (_| | | | (_| | (_| | ||  __/ | |____| | |  __/ (_| |  __/ | | | |_| | (_| | \__ \
    \/ \__,_|_|_|\__,_|\__,_|\__\___|  \_____|_|  \___|\__,_|\___|_| |_|\__|_|\__,_|_|___/

*/

BEGIN;

  SELECT plan(1);

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'validate_credentials',
      ARRAY[ 'JSONB' ],
      'Function validate_credentials(jsonb) exists'
  );
  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;
