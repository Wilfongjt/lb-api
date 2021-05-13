\c one_db;

SET search_path TO api_0_0_1, base_0_0_1, public;



/*
 _               _                   _       _
| |             | |                 | |     | |
| |__   __ _  __| |  _   _ _ __   __| | __ _| |_ ___
| '_ \ / _` |/ _` | | | | | '_ \ / _` |/ _` | __/ _ \
| |_) | (_| | (_| | | |_| | |_) | (_| | (_| | ||  __/
|_.__/ \__,_|\__,_|  \__,_| .__/ \__,_|\__,_|\__\___|
                          | |
                          |_|

*/
  --=======================================
  -- UPDATE
  --=======================================
  -- missing bad keys
BEGIN;

insert into base_0_0_1.one
  (pk, sk, tk, form, created, owner)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3'
  );

  SELECT plan(4);
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'update',
      ARRAY[ 'JSONB' ],
      'Function Update (_chelate JSONB) exists'
  );

  --  1
  SELECT is (
    base_0_0_1.update('{
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'Update Bad no keys form Bad Request 0_0_1'::TEXT
  );
  -- 2
  SELECT is (
    base_0_0_1.update('{
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'Update Bad tk only form Bad Request 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.update('{
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"update@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'Update Bad sk tk form Bad Request 0_0_1'::TEXT
  );
  -- 4
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#update@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
      }'::JSONB)::JSONB ->> 'msg',
      'Bad Request'::TEXT,
      'Update Bad pk sk tk NO form Bad Request 0_0_1'::TEXT
  );
  -- 5
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#unknown820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"unknown@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'Update Bad pk sk tk form PK Not Found 0_0_1'::TEXT
  );
  -- 6
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#unknown820a5bd9-e669-41d4-b917-81212bc184a3",
      "form":{"username":"unknown@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
            }
      }'::JSONB)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'Update Bad badpk sk tk form PK Not Found 0_0_1'::TEXT
  );

  SELECT * FROM finish();

ROLLBACK;

/*
more update
                 _       _
                | |     | |
 _   _ _ __   __| | __ _| |_ ___
| | | | '_ \ / _` |/ _` | __/ _ \
| |_| | |_) | (_| | (_| | ||  __/
 \__,_| .__/ \__,_|\__,_|\__\___|
      | |
      |_|



*/
--=======================================
-- UPDATE
--=======================================
-- new keys
-- No change
-- key change
-- form change
-- key and form change

BEGIN;
insert into base_0_0_1.one
  (pk, sk, tk, form, created, owner)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3'
  );
  
  SELECT plan(4);

  -- Not Found with a change
  SELECT is (
    base_0_0_1.update('{
      "pk":"username#unknown@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
          "username":"update2@user.com",
          "displayname":"J",
          "const":"USER",
          "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
        }
      }'::JSONB)::JSONB ->> 'msg',
      'Not Found'::TEXT,
      'Update Not Found with Change  0_0_1'::TEXT
  );

  -- No change

  SELECT is (
    base_0_0_1.update('{
      "pk":"username#update@user.com",
      "sk":"const#USER",
      "tk":"guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
          "username":"update@user.com",
          "displayname":"J",
          "const":"USER",
          "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
        }
      }'::JSONB)::JSONB ->> 'msg',
      'OK'::TEXT,
      'Update No change OK  0_0_1'::TEXT
  );
  -- Form change OK
 SELECT is (
   base_0_0_1.update(
       '{
         "pk":"username#update@user.com",
         "sk":"const#USER",
         "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
         "form":{
                 "username":"update@user.com",
                 "displayname":"K",
                 "const":"USER",
                 "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
               }
        }'::JSONB
     )::JSONB ->> 'msg',
     'OK'::TEXT,
     'Update displayname change OK  0_0_1'::TEXT
 );

 --   Single Key Change only
 SELECT is (
   base_0_0_1.update(
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "username":"CHANGEupdate@user.com",
               "displayname":"J",
               "const":"USER",
               "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
             }
      }'::JSONB
     )::JSONB ->> 'msg',
     'OK'::TEXT,
     'Update pk key change OK  0_0_1'::TEXT
 );
 --   Multiple Key Change
 SELECT is (
   base_0_0_1.update(
     '{
       "pk":"username#update@user.com",
       "sk":"const#USER",
       "tk":"guid#d820a5bd9-e669-41d4-b917-81212bc184a3",
       "form":{
               "username":"CHANGEupdate@user.com",
               "displayname":"J",
               "const":"CHANGETEST",
               "guid":"820a5bd9-e669-41d4-b917-81212bc184a3"
             }
      }'::JSONB
     )::JSONB ->> 'msg',
     'Not Found'::TEXT,
     'Update, DOUBLE PUMP on an update 0_0_1'::TEXT
 );

  SELECT * FROM finish();

ROLLBACK;
