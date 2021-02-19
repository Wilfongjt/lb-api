-- hashed with password = PASSWORDmustBEATLEAST32CHARSLONGLONG

insert into one_base.one
  (pk, sk, tk, form)
  values (
  'testname#connection-test',
  'guid#abc420a5bd9-e669-41d4-b917-81212bc184a3',
  'const#TEST',
  '{ "testname":"connection-test"}'::JSONB
  );

insert into one_base.one
  (pk, sk, tk, form)
  values (
  'username#selectchange@user.com',
  'const#USER',
  'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
  '{ "username": "selectchange@user.com",
                "displayname": "J",
                "password": {
                  "hash":"048a1d2b6056d6589f8f63f48cf77165f5cff56e56663d1a9195ded9e230ee355b1abb8c22b3fb9ec409f02bc8a725f148988efaa233b30e1333aa1a28198703",
                  "salt":"707bb65c19e52f452b17b51eb5d0b943"
                }
    }'::JSONB
  );
  insert into one_base.one
    (pk, sk, tk, form)
    values (
    'username#selectchange@user.com',
    'const#PASSWORD',
    'guid#420a5bd9-e669-41d4-b917-81212bc184a3',
    '{
        "password": {
          "hash":"048a1d2b6056d6589f8f63f48cf77165f5cff56e56663d1a9195ded9e230ee355b1abb8c22b3fb9ec409f02bc8a725f148988efaa233b30e1333aa1a28198703",
          "salt":"707bb65c19e52f452b17b51eb5d0b943"
        }
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
              "password":{"hash":"8f449a2b2ba005fe2b6cfca88939b0e248f564b45ed08337741ed0bcde986fc4143c0573b586fe963d2c005ab98affbea9bed368803de2815443e9da26d2410b",
                          "salt":"972a629e0ef0a1872cb454264119fd61"
                        }
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
              "password":{
                "hash":"a403d08ee736924374a2986f96bf1e980631eccb4abdd4fdbf92dfd3c24f54622481443751ebda81e49b070182d703e84a10856ac62c55851fa1d283b6e7db83",
                "salt":"b9b07d5efc437ee709f18a35f4efd916"
              }
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
              "password":{
                "hash":"a1206265529a1b85c66d9b6eeba84d0cf3f7fe824b30cd4654fcfcaf43d1c53a85a87fba8312cb4199ed246272d0958b7ca485c2ff29b4677e31af41b52e86f8",
                "salt":"edfa20bda66b5eb9014b30c46914cf53"
              }
       }'::JSONB
  );
insert into one_base.one
  (pk, sk, tk, form)
  values (
      'username#update@user.com',
      'const#USER',
      'guid#820a5bd9-e669-41d4-b917-81212bc184a3',
      '{"username":"update@user.com",
              "displayname":"J",
              "password":{
                "hash":"4802a10ae464b8c4cd2635c3d7b1ac8a40760ef49101a7a35c2629f6e0a2f2bc51e6a51d4837408be93cf4c2d74bed31fc8c3835a7590e9bd6c9d2533bf496b8",
                "salt":"4b24582a5ae088b8fb6fd3f353d63d6f"
              }
       }'::JSONB
  );
