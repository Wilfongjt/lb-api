-- hashed with password = PASSWORDmustBEATLEAST32CHARSLONGLONG

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
  'username#selectchange@user.com',
  'const#USER',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J",
                "scope":"api_user",
                "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
    }'::JSONB,
    'guid#420a5bd9-e669-41d4-b917-81212bc184a3'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
  'username#selectchange@user.com',
  'const#PASSWORD',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{
      "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
    }'::JSONB,
    'guid#420a5bd9-e669-41d4-b917-81212bc184a3'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
  'username#selectchange@user.com',
  'const#NAME',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J"
    }'::JSONB,
    'guid#420a5bd9-e669-41d4-b917-81212bc184a3'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#existing@user.com',
      'const#USER',
      'guid#520a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'guid#520a5bd9-e669-41d4-b917-81212bc184a3'
    );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#existing2@user.com',
      'const#USER',
      'guid#620a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing2@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
      }'::JSONB,
      'guid#620a5bd9-e669-41d4-b917-81212bc184a3'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#delete1@user.com',
      'const#USER',
      'guid#720a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"delete1@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'guid#720a5bd9-e669-41d4-b917-81212bc184a3'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#delete2@user.com',
      'const#USER',
      'guid#2720a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"delete2@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'guid#2720a5bd9-e669-41d4-b917-81212bc184a3'
  );

  insert into base_0_0_1.one
    (pk, sk, tk, form, owner)
    values (
      'guid#xx2720a5bd9-e669-41d4-b917-81212bc184a3',
        'const#USER',
        'username#delete3@user.com',
        '{"username":"delete3@user.com",
                "displayname":"J",
                "scope":"api_user",
                "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
         }'::JSONB,
         'guid#xx2720a5bd9-e669-41d4-b917-81212bc184a3'
    );
/*
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
*/
insert into base_0_0_1.one
  (pk, sk, tk, form, created, owner)
  values (
      'username#flip@user.com',
      'guid#920a5bd9-e669-41d4-b917-81212bc184a3',
      'const#FLIP',
      '{"username":"flip@user.com",
              "displayname":"J",
              "scope":"api_user",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374',
      'flip@user.com'
  );
