\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;

/*

      _                                _   _
     | |                              | | | |
  ___| |__   __ _ _ __   __ _  ___  __| | | | _____ _   _
 / __| '_ \ / _` | '_ \ / _` |/ _ \/ _` | | |/ / _ \ | | |
| (__| | | | (_| | | | | (_| |  __/ (_| | |   <  __/ |_| |
 \___|_| |_|\__,_|_| |_|\__, |\___|\__,_| |_|\_\___|\__, |
                         __/ |                       __/ |
                        |___/                       |___/

*/


BEGIN;

  SELECT plan(6);
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'changed_key',
      ARRAY[ 'JSONB' ],
      'Function Changed_Key (jsonb) exists'
  );
  -- 2
  SELECT is (
    base_0_0_1.changed_key(
      '{
        "pk":"username#update@user.com",
        "sk":"const#TEST",
        "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
        "form":{
                "displayname":"k"
              }
        }'::JSONB
    ),
    false,
    'No key changes when form missing key values and displayname changed 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.changed_key(
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
    ),
    false,
    'No key changes when form displayname changed 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.changed_key(
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
    ),
    true,
    'Detect pk key changes 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.changed_key(
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
    ),
    true,
    'Detect sk key changes 0_0_1'::TEXT
  );

  -- 6
  SELECT is (
    base_0_0_1.changed_key(
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
    ),
    true,
    'Detect pk sk tk key changes 0_0_1'::TEXT
  );
  -- 7
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "sk":"const#USER",
          "tk":"guid#8820a5bd9-e669-41d4-b917-81212bc184a3",
          "form":{
            "username":"username#update@user.com",
            "displayname":"k",
            "const": "const#USER"
          }
        }'::JSONB
    ),
    true,
    'Detect sk tk key changes 0_0_1'::TEXT
  );
  -- 8
  SELECT is (
    base_0_0_1.changed_key(
      '{
          "pk":"username#update@user.com",
          "sk":"const#USER",
          "form":{
            "username":"username#update@user.com",
            "displayname":"k",
            "const": "const#USER"
          }
        }'::JSONB
    ),
    true,
    'Detect pk sk key changes 0_0_1'::TEXT
  );
  -- 9

  SELECT is (
    base_0_0_1.changed_key(
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
    ),
    false,
    'Detect tk key changes 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;
