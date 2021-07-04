
\c one_db;

--SET search_path TO api_0_0_1,  base_0_0_1, public;
SET search_path TO base_0_0_1, public;


--==================
-- Chelate
--==================
/*
__      __   _ _     _       _          _____ _          _       _
\ \    / /  | (_)   | |     | |        / ____| |        | |     | |
 \ \  / /_ _| |_  __| | __ _| |_ ___  | |    | |__   ___| | __ _| |_ ___
  \ \/ / _` | | |/ _` |/ _` | __/ _ \ | |    | '_ \ / _ \ |/ _` | __/ _ \
   \  / (_| | | | (_| | (_| | ||  __/ | |____| | | |  __/ | (_| | ||  __/
    \/ \__,_|_|_|\__,_|\__,_|\__\___|  \_____|_| |_|\___|_|\__,_|\__\___|



*/

BEGIN;

  SELECT plan(2);

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'validate_chelate',
      ARRAY[ 'JSONB', 'TEXT' ],
      'Function validate_chelate(jsonb, TEXT) exists'
  );
  SELECT ok (
    base_0_0_1.validate_chelate(
      '{}'::JSONB,
      'pstfoacu'::TEXT
    )::JSONB is not NULL,
    'validate_chelate (chelate JSONB, expected TEXT) 0_0_1'::TEXT
  );
  SELECT ok (
    base_0_0_1.validate_chelate(
      '{
          "pk":"a#v1",
          "sk":"b#v2",
          "tk":"c#v3",
          "form": {
            "a":"v1",
            "b":"v2",
            "c":"v3",
            "d":"v4"
          }
        }'::JSONB,
        'PSTFoacu'::TEXT
    )::JSONB is not NULL,
    'validate_chelate (chelate JSONB, expected TEXT) 0_0_1'::TEXT
  );
  SELECT * FROM finish();

ROLLBACK;
-- END;

/*
BEGIN;

  SELECT plan(10);
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'chelate',
      ARRAY[ 'JSONB' ],
      'Function chelate(jsonb) exists'
  );

  SELECT ok (
    (base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              }
        }'::JSONB
    ) ->> 'form')::JSONB  = '{"displayname":"k"}'::JSONB,
    'chelate No key changes when form missing key values and displayname changed 0_0_1'::TEXT
  );

  -- chelate prove 'changed' is immutable 0_0_1
  SELECT ok (
    base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              },
        "created":"2021-02-21 20:44:47.442374"
        }'::JSONB
    ) ->> 'created' = '2021-02-21 20:44:47.442374',
    'chelate "changed" is immutable 0_0_1'::TEXT
  );
  SELECT ok (
    base_0_0_1.chelate(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              },
        "created":"2021-02-21 20:44:47.442374"
        }'::JSONB
    ) ->> 'updated' != '2021-02-21 20:44:47.442374',
    'chelate "updated" is mutable 0_0_1'::TEXT
  );
  -- no pk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk' = 'username#update@user.com',

    'chelate PK changes when form displayname changed 0_0_1'::TEXT
  );
  -- no sk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'sk' = 'const#TEST',

    'chelate SK changes when form displayname changed 0_0_1'::TEXT
  );

  -- no tk change
  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'tk' = 'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
    'chelate TK changes when form displayname changed 0_0_1'::TEXT
  );

  SELECT ok (
    (base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
        	  "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk') = 'username#CHANGEupdate@user.com',

    'chelate Detect pk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'sk' = 'const#CHANGETEST',

    'chelate Detect sk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"update@user.com",
            "displayname":"k",
            "const": "TEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'tk' = 'guid#CHANGE820a5bd9-e669-41d4-b917-81212bc184a3',

    'chelate Detect tk key changes 0_0_1'::TEXT
  );

  SELECT ok (
    base_0_0_1.chelate(
      '{
          "pk":"username#update@user.com",
          "sk":"const#TEST",
          "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"CHANGEupdate@user.com",
            "displayname":"k",
            "const": "CHANGETEST",
            "guid": "CHANGE820a5bd9-e669-41d4-b917-81212bc184a3"
          }
        }'::JSONB
    ) ->> 'pk' = 'username#CHANGEupdate@user.com',
    'chelate Detect pk sk tk key changes 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;
*/
