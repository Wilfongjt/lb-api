
\c one_db;

SET search_path TO api_0_0_1,  base_0_0_1, public;



--==================
-- Chelate
--==================
/*
  _____ _          _       _
 / ____| |        | |     | |
| |    | |__   ___| | __ _| |_ ___
| |    | '_ \ / _ \ |/ _` | __/ _ \
| |____| | | |  __/ | (_| | ||  __/
 \_____|_| |_|\___|_|\__,_|\__\___|

*/
/* value found in table
'username#update@user.com',
'const#TEST',
'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
'{"username":"update@user.com",
        "displayname":"J",
        "password":{
          "hash":"4802a10ae464b8c4cd2635c3d7b1ac8a40760ef49101a7a35c2629f6e0a2f2bc51e6a51d4837408be93cf4c2d74bed31fc8c3835a7590e9bd6c9d2533bf496b8",
          "salt":"4b24582a5ae088b8fb6fd3f353d63d6f"
        }
 }
*/
BEGIN;

  SELECT plan(2);

  -- 1
  SELECT has_function(
      'base_0_0_1',
      'chelate',
      ARRAY[ 'JSONB', 'JSONB' ],
      'Function chelate(jsonb, jsonb) exists'
  );
  SELECT ok (
    base_0_0_1.chelate(
      '{"pk":"a","sk":"b","tk":"c"}'::JSONB,
      '{
          "a":"v1",
          "b":"v2",
          "c":"v3",
          "d":"v4"
        }'::JSONB
    )::JSONB ->> 'pk' = 'a#v1',
    'chelate (keys JSONB, form JSONB) 0_0_1'::TEXT
  );
  SELECT * FROM finish();

ROLLBACK;

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
