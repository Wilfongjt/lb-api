
\c one_db;

SET search_path TO api_0_0_1, public;

/*
 _        _     _
| |      | |   | |
| |_ __ _| |__ | | ___
| __/ _` | '_ \| |/ _ \
| || (_| | |_) | |  __/
 \__\__,_|_.__/|_|\___|

*/
-------------------
--
------------------
BEGIN;

  SELECT plan(3);

  SELECT has_table('base_0_0_1', 'one', 'has table');

  SELECT hasnt_pk('base_0_0_1', 'one', 'has no primary key');

  -- TEST: Test event_logger Insert
  SELECT * FROM finish();

ROLLBACK;
