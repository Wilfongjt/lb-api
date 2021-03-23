-- hashed with password = PASSWORDmustBEATLEAST32CHARSLONGLONG

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
  'username#selectchange@user.com',
  'const#USER',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J",
                "scope":"editor",
                "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
    }'::JSONB,
    'selectchange@user.com'
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
    'selectchange@user.com'
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
    'selectchange@user.com'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#existing@user.com',
      'const#USER',
      'guid#520a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'existing@user.com'
    );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#existing2@user.com',
      'const#USER',
      'guid#620a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing2@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
      }'::JSONB,
      'existing2@user.com'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#delete1@user.com',
      'const#USER',
      'guid#720a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"delete1@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'delete1@user.com'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, owner)
  values (
      'username#delete2@user.com',
      'const#USER',
      'guid#2720a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"delete2@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
       'delete2@user.com'
  );

  insert into base_0_0_1.one
    (sk, tk, form, owner)
    values (
        'const#USER',
        'username#delete3@user.com',
        '{"username":"delete3@user.com",
                "displayname":"J",
                "scope":"editor",
                "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
         }'::JSONB,
         'delete3@user.com'
    );

insert into base_0_0_1.one
  (pk, sk, tk, form, created, owner)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374',
      'update@user.com'
  );

insert into base_0_0_1.one
  (pk, sk, tk, form, created, owner)
  values (
      'username#flip@user.com',
      'guid#920a5bd9-e669-41d4-b917-81212bc184a3',
      'const#FLIP',
      '{"username":"flip@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374',
      'flip@user.com'
  );
