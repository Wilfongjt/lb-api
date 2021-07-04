\c one_db;

SET search_path TO base_0_0_1, public;

/*

*/

BEGIN;

  SELECT plan(1);

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'is_valid_token',
      ARRAY[ 'TEXT', 'TEXT' ],
      'Function is_valid_token(token, expected_scope)'
  );

  SELECT ok (
    base_0_0_1.is_valid_token(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJseXR0bGViaXQtYXBpIiwiaXNzIjoibHl0dGxlYml0Iiwic3ViIjoiY2xpZW50LWFwaSIsInVzZXIiOiJndWVzdCIsInNjb3BlIjoiYXBpX2d1ZXN0Iiwia2V5IjoiMCJ9.vslejaXLJibyooozst_2XNUICkhEj9ENwr_9OSoHsp8'::TEXT,
      'api_guest'::TEXT
    )::BOOLEAN,
    'is_valid_token(token TEXT, expected_scope TEXT) 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.is_valid_token(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"guest", "key":"0", "scope":"api_guest"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      'api_guest'::TEXT
    )::BOOLEAN,
    'is_valid_token(token TEXT, expected_scope is api_guest TEXT) 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.is_valid_token(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"existing@user.com", "key":"0", "scope":"api_user"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      'api_user'::TEXT
    )::BOOLEAN,
    'is_valid_token(token TEXT, expected_scope is api_user TEXT) 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.is_valid_token(
      sign((current_setting('app.postgres_jwt_claims')::JSONB || '{"user":"existing@user.com", "key":"0", "scope":"api_admin"}'::JSONB)::JSON, current_setting('app.settings.jwt_secret'))::TEXT,
      'api_admin'::TEXT
    )::BOOLEAN,
    'is_valid_token(token TEXT, expected_scope is api_admin TEXT) 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
-- END;
