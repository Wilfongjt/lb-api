import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
}
import DbClientPoolPostgres from '../../../lib/clients/postgres/db_client_pool_postgres.js';
import DbClientPostgres from '../../../lib/clients/postgres/db_client_postgres.js';
import { Chelate } from '../../../lib/chelates/chelate.js';

// the pool will emit an error on behalf of any idle clients
// it contains if a backend error or network partition happens

describe('New DbPoolPostgres', () => {
  const config = {
    user: process.env.PGUSER || 'postgres',
    host: 'localhost'|| process.env.PGHOST || 'db',
    database: process.env.PGDATABASE || 'one_db',
    password: process.env.PGPASSWORD || 'mysecretdatabasepassword',
    port: process.env.PGPORT || 5433,
    guest_token: process.env.LB_API_GUEST_TOKEN,
    Client: DbClientPostgres
  };
  // console.log('startup the pool');
  const pool = new DbClientPoolPostgres(config, new DbClientPostgres(config)); // warm up the pool

  beforeAll(() => {
    //console.log('start pool');
  });

  afterAll(() => {
    //console.log('end pool');
    pool.end();
  });
  // Initialize
  test('DbPoolPostgres DbClientPostgres client', async () => {
      const client = await pool.connect();

      try {
        // is the extended class getting initiated
        expect((client instanceof DbClientPostgres)).toEqual(true);
      } finally {
        client.release();
      }

  })
  // QUERY ""
  test('DbPoolPostgres.query(\'\')', async () => {
      const client = await pool.connect();

      try {
        let queryResult = await client.query('');
        //console.log('queryResult',queryResult);
        expect(queryResult.status).toEqual('400');
        expect(queryResult.msg).toEqual('Bad Request');
        expect(queryResult.selection.length).toEqual(0);
      } finally {
        client.release();
      }

  })

  // QUERY {}
  test('DbPoolPostgres.query({})', async () => {
      const client = await pool.connect();

      try {

        let queryResult = await client.query({});
        expect(queryResult.status).toEqual('400');
        expect(queryResult.msg).toEqual('Bad Request');

        expect(queryResult.selection.length).toEqual(0);
      } finally {
        client.release();
      }

  })

  // QUERY {pk:"" sk: ""}
  test('DbPoolPostgres.query({"pk":"", "sk":""})', async () => {
      const client = await pool.connect();
      const criteria = {"pk":"", "sk":""};

      try {

        let queryResult = await client.query(criteria);
//console.log('queryResult', queryResult);
        expect(queryResult.status).toEqual('404');
        expect(queryResult.msg).toEqual('Not Found');

        expect(queryResult.selection.length).toEqual(0);
      } finally {
        client.release();
      }

  })
  test('DbPoolPostgres.query({"pk":"username#existing@user.com", "sk":""})', async () => {
      const client = await pool.connect();
      const criteria = {"pk":"username#existing@user.com", "sk":""};

      try {

        let queryResult = await client.query(criteria);

        expect(queryResult.status).toEqual('404');
        expect(queryResult.msg).toEqual('Not Found');
        expect(queryResult.selection.length).toEqual(0);
      } finally {
        client.release();
      }

  })

  test('DbPoolPostgres.query({"pk":"", "sk":"const#USER"})', async () => {
      const client = await pool.connect();
      const criteria = {"pk":"", "sk":"const#USER"};

      try {

        let queryResult = await client.query(criteria);

        expect(queryResult.status).toEqual('404');
        expect(queryResult.msg).toEqual('Not Found');
        expect(queryResult.selection.length).toEqual(0);
      } finally {
        client.release();
      }

  })

  test('DbPoolPostgres.query({"pk":"username#existing@user.com", "sk":"const#USER"})', async () => {
      const client = await pool.connect();
      const criteria = {"pk":"username#existing@user.com", "sk":"const#USER"};

      try {

        let queryResult = await client.query(criteria);

        expect(queryResult.status).toEqual('200');
        expect(queryResult.msg).toEqual('OK');
        expect(queryResult.selection.length).toEqual(1);
      } finally {
        client.release();
      }

  })

  test('DbPoolPostgres.query({"pk":"username#existing@user.com", "sk":"*"})', async () => {
      const client = await pool.connect();
      const criteria = {"pk":"username#existing@user.com", "sk":"*"};

      try {

        let queryResult = await client.query(criteria);
        //console.log('queryResult', queryResult);
        expect(queryResult.status).toEqual('200');
        expect(queryResult.msg).toEqual('OK');
        expect(queryResult.selection.length).toEqual(1);
        expect(queryResult.selection[0].pk).toEqual('username#existing@user.com');
      } finally {
        client.release();
      }

  })
  test('DbPoolPostgres.query({"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"})', async () => {
      const client = await pool.connect();
      const criteria = {"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"};

      try {

        let queryResult = await client.query(criteria);
        //console.log('queryResult', queryResult);
        expect(queryResult.status).toEqual('200');
        expect(queryResult.msg).toEqual('OK');
        expect(queryResult.selection.length).not.toEqual(0);
        //expect(queryResult.selection[0].pk).toEqual('username#existing@user.com');
      } finally {
        client.release();
      }

  })
  test('DbPoolPostgres.query({"sk":"const#USER", "tk":"*"})', async () => {
      const client = await pool.connect();
      const criteria = {"sk":"const#USER", "tk":"*"};

      try {

        let queryResult = await client.query(criteria);
        //console.log('queryResult', queryResult);
        //console.log('queryResult[0]', queryResult.selection[0]);

        expect(queryResult.status).toEqual('200');
        expect(queryResult.msg).toEqual('OK');
        expect(queryResult.selection.length).not.toEqual(0);
        //expect(queryResult.selection[0].pk).toEqual('username#existing@user.com');
      } finally {
        client.release();
      }

  })

  test('DbPoolPostgres.query({"xk":"const#FLIP", "yk":"guid#..."})', async () => {
      const client = await pool.connect();
      const criteria = {xk:"const#FLIP", yk:"guid#920a5bd9-e669-41d4-b917-81212bc184a3"};

      try {

        let queryResult = await client.query(criteria);
        //console.log('queryResult', queryResult);
        //console.log('queryResult[0]', queryResult.selection[0]);

        expect(queryResult.status).toEqual('200');
        expect(queryResult.msg).toEqual('OK');
        expect(queryResult.selection.length).not.toEqual(0);
        //expect(queryResult.selection[0].pk).toEqual('username#existing@user.com');
      } finally {
        client.release();
      }
  })

  // DELETE
  test('DbPoolPostgres Delete unknown record', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();
        const criteria = {"pk":"username#unknown@user.com", "sk":"const#USER"};
        let deleteResult = await client.delete(criteria);
        expect(deleteResult.status).toEqual('404');
        expect(deleteResult.msg).toEqual('Not Found');

      } finally {
        await client.rollbackTransaction();

        client.release();
      }

  })
  test('DbPoolPostgres Delete known record', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();
        const criteria = {"pk":"username#delete@user.com", "sk":"const#USER"};
        let deleteResult = await client.delete(criteria);
        expect(deleteResult.status).toEqual('200');
        expect(deleteResult.msg).toEqual('OK');

      } finally {
        await client.rollbackTransaction();

        client.release();
      }

  })

  // INSERT
  test('DbPoolPostgres Insert singleton', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();
        // start the insert
        let key_map = {
          pk:{att: "email"},
          sk:{att: "type"},
          tk:{att: "displayname"}        // * is flag to calculate guid when not provided
        };
        let form = {
          "email":"abc@xyz.com",
          "type":"USER",
          "displayname":"abc",
          "password":"a1A!aaaa"
         };

        let insertResult = await client.insert(new Chelate(key_map, form));
        //console.log('insertResult',insertResult);
        expect(insertResult.status).toEqual('200');
        expect(insertResult.msg).toEqual('OK');
        expect(insertResult.insertion.created).toBeTruthy();

      } finally {
        await client.rollbackTransaction();

        client.release();
      }

  })
  test('DbPoolPostgres Insert duplicate', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();
        // start the insert
        let key_map = {
          pk:{att: "username"},
          sk:{const: "USER"},
          tk:{guid: "520a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
        };
        let form = {
          "username":"existing@user.com",
          "displayname":"J",
          "password":"a1A!aaaa"
         };

        let insertResult = await client.insert(new Chelate(key_map, form));
        //console.log('insertResult',insertResult);
        expect(insertResult.status).toEqual('409');
        expect(insertResult.msg).toEqual('Duplicate');

      } finally {
        await client.rollbackTransaction();

        client.release();
      }

  })
  // UPDATE
  test('DbPoolPostgres Update pk form, 400', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();

        let key_map = {
          pk:{att: "username"}
        };

        let form = {
          "username":"update@user.com",
          "displayname":"K",
          "password":"a1A!aaaa"
         };

        let updateResult = await client.update(new Chelate(key_map, form));

        expect(updateResult.status).toEqual('400');
        expect(updateResult.msg).toEqual('Bad Request');

      } finally {
        await client.rollbackTransaction();
        client.release();
      }
  })

  test('DbPoolPostgres Update single, sk form, 400', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();

        let key_map = {
          sk:{const: "USER"}
        };

        let form = {
          "username":"update@user.com",
          "displayname":"K",
          "password":"a1A!aaaa"
         };

        let updateResult = await client.update(new Chelate(key_map, form));

        expect(updateResult.status).toEqual('400');
        expect(updateResult.msg).toEqual('Bad Request');

      } finally {
        await client.rollbackTransaction();
        client.release();
      }
  })

  test('DbPoolPostgres Update single, tk form, 400', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();

        let key_map = {
          tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
        };

        let form = {
          "username":"update@user.com",
          "displayname":"K",
          "password":"a1A!aaaa"
         };

        let updateResult = await client.update(new Chelate(key_map, form));

        expect(updateResult.status).toEqual('400');
        expect(updateResult.msg).toEqual('Bad Request');

      } finally {
        await client.rollbackTransaction();
        client.release();
      }
  })

  test('DbPoolPostgres Update single, pk tk form, 400', async () => {
      const client = await pool.connect();

      try {
        await client.startTransaction();

        let key_map = {
          pk:{att: "username"},
          tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
        };

        let form = {
          "username":"update@user.com",
          "displayname":"K",
          "password":"a1A!aaaa"
         };

        let updateResult = await client.update(new Chelate(key_map, form));

        expect(updateResult.status).toEqual('400');
        expect(updateResult.msg).toEqual('Bad Request');

      } finally {
        await client.rollbackTransaction();
        client.release();
      }
  })


    test('DbPoolPostgres Update single, sk tk form, 400', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let key_map = {
            sk:{const: "USER"},
            tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
          };

          let form = {
            "username":"update@user.com",
            "displayname":"K",
            "password":"a1A!aaaa"
           };

          let updateResult = await client.update(new Chelate(key_map, form));

          expect(updateResult.status).toEqual('400');
          expect(updateResult.msg).toEqual('Bad Request');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })

    test('DbPoolPostgres Update single, pk sk form, no change', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let key_map = {
            pk:{att: "username"},
            sk:{const: "USER"},
          };

          let form = {
            "username":"update@user.com",
            "displayname":"K",
            "password":"a1A!aaaa"
           };

          let updateResult = await client.update(new Chelate(key_map, form));

          expect(updateResult.status).toEqual('200');
          expect(updateResult.msg).toEqual('OK');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })

    test('DbPoolPostgres Update single, pk sk form, form change', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let key_map = {
            pk:{att: "username"},
            sk:{const: "USER"},
          };

          let form = {
            "username":"update@user.com",
            "displayname":"JChanged",
            "password":"a1A!aaaa"
           };

          let updateResult = await client.update(new Chelate(key_map, form));

          expect(updateResult.status).toEqual('200');
          expect(updateResult.msg).toEqual('OK');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })

    test('DbPoolPostgres Update single, pk sk form, pk change', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let chelate = {
            "pk":"username#update@user.com",
            "sk":"const#USER",
            "form": {
              "username":"updateChange@user.com",
              "displayname":"J",
              "password":"a1A!aaaa"
             }
           };

          let updateResult = await client.update(chelate);

          expect(updateResult.status).toEqual('200');
          expect(updateResult.msg).toEqual('OK');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })
    test('DbPoolPostgres SignIn no credentials, ', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let credentials = {
            };
          let updateResult = await client.signin(credentials);

          expect(updateResult.status).toEqual('400');
          expect(updateResult.msg).toEqual('Bad Request');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })
    test('DbPoolPostgres SignIn, no username ', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let credentials = {
            "password":"a1A!aaaa"
            };
          let updateResult = await client.signin(credentials);

          expect(updateResult.status).toEqual('400');
          expect(updateResult.msg).toEqual('Bad Request');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })
    test('DbPoolPostgres SignIn, no password ', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let credentials = {
              "username":"existing@user.com"
            };
          let updateResult = await client.signin(credentials);

          expect(updateResult.status).toEqual('400');
          expect(updateResult.msg).toEqual('Bad Request');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })

    test('DbPoolPostgres SignIn, good ', async () => {
        const client = await pool.connect();

        try {
          await client.startTransaction();

          let credentials = {
              "username":"existing@user.com",
              "password":"a1A!aaaa"
            };
          let updateResult = await client.signin(credentials);

          expect(updateResult.status).toEqual('200');
          expect(updateResult.msg).toEqual('OK');

        } finally {
          await client.rollbackTransaction();
          client.release();
        }
    })

});
