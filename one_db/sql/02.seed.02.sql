-- hashed with password = PASSWORDmustBEATLEAST32CHARSLONGLONG
/*
insert into one_base.one
  (pk, sk, tk, form)
  values (
  'username#selectchange@user.com',
  'const#USER',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J",
                "scope":"editor",
                "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
    }'::JSONB
  );
  insert into one_base.one
    (pk, sk, tk, form)
    values (
    'username#selectchange@user.com',
    'const#PASSWORD',
    'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
    '{
        "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
      }'::JSONB
    );
insert into one_base.one
  (pk, sk, tk, form)
  values (
  'username#selectchange@user.com',
  'const#NAME',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J"
    }'::JSONB
  );
insert into one_base.one
  (pk, sk, tk, form)
  values (
      'username#existing@user.com',
      'const#USER',
      'guid#520a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB
    );

insert into one_base.one
  (pk, sk, tk, form)
  values (
      'username#existing2@user.com',
      'const#USER',
      'guid#620a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"existing2@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
      }'::JSONB
  );

insert into one_base.one
  (pk, sk, tk, form)
  values (
      'username#delete@user.com',
      'const#USER',
      'guid#720a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"delete@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB
  );
insert into one_base.one
  (pk, sk, tk, form, created)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "scope":"editor",
              "password": "$2a$06$TXVF4CDfUcHXvTeOIGrEn.BSGbbCzLxMu2t8tyZimKtsBRxxyeQBK"
       }'::JSONB,
      '2021-02-21 20:44:47.442374'
  );
*/
