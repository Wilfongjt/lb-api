\c one_db;

SET search_path TO api_0_0_1,  base_0_0_1, public;

/*
 __      __   _ _     _       _         ______
 \ \    / /  | (_)   | |     | |       |  ____|
  \ \  / /_ _| |_  __| | __ _| |_ ___  | |__ ___  _ __ _ __ ___
   \ \/ / _` | | |/ _` |/ _` | __/ _ \ |  __/ _ \| '__| '_ ` _ \
    \  / (_| | | | (_| | (_| | ||  __/ | | | (_) | |  | | | | | |
     \/ \__,_|_|_|\__,_|\__,_|\__\___| |_|  \___/|_|  |_| |_| |_|



*/

BEGIN;

  SELECT plan(1);

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'validate_form',
      ARRAY[ 'TEXT[]', 'JSONB' ],
      'Function validate_form(text[], jsonb) exists'
  );
  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;
