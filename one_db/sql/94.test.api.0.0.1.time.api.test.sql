/*
\c one_db;

--SET search_path TO api_0_0_1,  base_0_0_1, public;
SET search_path TO base_0_0_1, public;



-- TIME

--------------------
-- TIME Tests
--------------------
BEGIN;

  SELECT plan(1);
  -- TEST: Test time
  -- 1 Time
  SELECT has_function(
      'base_0_0_1',
      'time',
      ARRAY[ ],
      'Function time () exists'
  );


  SELECT * FROM finish();

ROLLBACK;
-- END;
*/
