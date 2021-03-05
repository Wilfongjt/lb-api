
/*
use the pool version db_pool_postgres.testjs


import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
}
import Const from '../../../lib/constants/consts.js';
import DataTypes from '../../../lib/constants/data_types.js';

import DbClientPostgres from '../../../lib/clients/postgres/db_client_postgres.js';

import { Chelate } from '../../../lib/chelates/chelate.js';
import { ChelateUser } from '../../../lib/chelates/chelate_user.js';

import { CriteriaBest } from '../../../lib/clients/criteria.js';

const { Pool } = require('pg');
const pool = new Pool();
//const pool = new DbClientPoolPostgres();

describe('DbClientPostgres', () => {
  // Initialize
  const config = {
    user: process.env.PGUSER || 'postgres',
    host: 'localhost'|| process.env.PGHOST || 'db',
    database: process.env.PGDATABASE || 'one_db',
    password: process.env.PGPASSWORD || 'mysecretdatabasepassword',
    port: process.env.PGPORT || 5433,
    Client: DbClientPostgres
  };
*/
  //let client ;
/*
  beforeEach(async () => {
    client = new DbClientPostgres(config);
    client.connect();
    client.startTransaction();
  });

  afterEach(() => {
    client.rollbackTransaction();

    //client.close()
  });
  */
  /*
  test('new DbClientPostgres', () => {
    expect(new DbClientPostgres(config)).toBeDefined();
  })

  test('client.connect()', () => {
    let client = new DbClientPostgres(config);

    expect(client.connect()).toBeDefined();
    client.end();
  })
*/
/*
  test('Select All, BAD client.query(\"\")', async () => {

    let client = new DbClientPostgres(config);
    //client.startTransaction();

    await client.connect();
    let queryResult = await client.query('');

    expect(queryResult.selection.length).toEqual(0);

    client.end();
    //client.rollbackTransaction();
    //client.release();
  })

  test('Select All, BAD client.query({})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    let queryResult = await client.query({});

    expect(queryResult.selection.length).toEqual(0);

    client.end();
  })

  test('Select singleton,  client.query({"pk":"username#existing@user.com", "sk":"const#USER"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"pk":"username#existing@user.com", "sk":"const#USER"};

    let queryResult = await client.query(criteria);

    client.end();
    //console.log('Select singleton queryResult',queryResult);
    expect(queryResult.selection.length).toEqual(1);

  })

  test('Select many,  client.query({"pk":"username#selectchange@user.com", "sk":"*"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"pk":"username#selectchange@user.com", "sk":"*"};

    let queryResult = await client.query(criteria);

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })

  test('Select single,  client.query({"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"};

    let queryResult = await client.query(criteria);

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })

  test('Select many,  client.query({"sk":"const#USER", "tk":"*"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"sk":"const#USER", "tk":"*"};

    let queryResult = await client.query(criteria);
    //console.log('Select many queryResult',JSON.stringify(queryResult));

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })

  test('Select many,  client.query({"xk":"const#FLIP", "yk":"guid#..."})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    //const criteria = {"xk":"woden", "yk":"woden@citizenlabs.org"};
    let criteria = new CriteriaBest({xk:"const#FLIP", yk:"guid#920a5bd9-e669-41d4-b917-81212bc184a3"});

    let queryResult = await client.query(criteria);
    //console.log('Select queryResult',JSON.stringify(queryResult));

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })
*/

  // Delete
/*
  test('Delete single by primary key,  client.delete({"pk":"delete@user.com", "sk":"const#USER"})', async () => {

    let client = new DbClientPostgres(config);

    await client.connect();
    //await client.startTransaction();

    const criteria = {"pk":"username#delete@user.com", "sk":"const#USER"};

    let deleteResult = await client.delete(criteria);
    //console.log('Delete one deleteResult',JSON.stringify(deleteResult));
    //client.end();
    expect(deleteResult.status).toEqual('200');
    //client.rollbackTransaction();
    client.end();
  })

  // Insert Good 200
  test('Insert single', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    // delete record if there
    const criteria = {"pk":"email#abc@xyz.com", "sk":"type#USER"};
    let deleteResult = await client.delete(criteria); //clean up
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
     //console.log('helate', new Chelate(key_map, form));

    //let insertResult = await client.insert(new Chelate(key_map, form);
    let insertResult = await client.insert(new Chelate(key_map, form));
    //console.log('insertResult', insertResult);
    deleteResult = await client.delete(criteria);
    client.end();
    expect(insertResult.status).toEqual('200');
    expect(insertResult.msg).toEqual('OK');

  })
  // Insert Duplicate 409
  test('Insert duplicate', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
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
     //console.log('dup chelate', new Chelate(key_map, form));
    let insertResult = await client.insert(new Chelate(key_map, form));
    client.end();
    expect(insertResult.status).toEqual('409');
    expect(insertResult.msg).toEqual('Duplicate');
  })

  // Update
  test('Update empty chelate 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    //console.log('update chelate', {});
    let updateResult = await client.update({});

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })

  test('Update single, pk form 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      pk:{att: "username"}
    };

    let form = {
      "username":"update@user.com",
      "displayname":"K",
      "password":"a1A!aaaa"
     };
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })

  test('Update single, sk form 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      sk:{const: "USER"}
    };

    let form = {
      "username":"update@user.com",
      "displayname":"K",
      "password":"a1A!aaaa"
     };
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })

  test('Update single, tk form 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
    };

    let form = {
      "username":"update@user.com",
      "displayname":"K",
      "password":"a1A!aaaa"
     };
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })


  test('Update single, pk tk form 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      pk:{att: "username"},
      tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
    };

    let form = {
      "username":"update@user.com",
      "displayname":"K",
      "password":"a1A!aaaa"
     };
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })


  test('Update single, sk tk form 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      sk:{const: "USER"},
      tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
    };

    let form = {
      "username":"update@user.com",
      "displayname":"K",
      "password":"a1A!aaaa"
     };
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })

  test('Update single, pk sk 404', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      sk:{const: "USER"},
      tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
    };

    let form = {};
    //console.log('update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));

    client.end();

    expect(updateResult.status).toEqual('400');
    expect(updateResult.msg).toEqual('Bad Request');
  })


  test('Update single, pk sk form, no change', async () => {
    let client = new DbClientPostgres(config);

    await client.connect();

    let key_map = {
      pk:{att: "username"},
      sk:{const: "USER"},
      tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
    };

    let form = {
      "username":"update@user.com",
      "displayname":"J",
      "password":"a1A!aaaa"
     };
    //console.log('test update chelate', new Chelate(key_map, form));
    let updateResult = await client.update(new Chelate(key_map, form));
    //console.log('test update ', updateResult);
    client.end();

    expect(updateResult.status).toEqual('200');
    expect(updateResult.msg).toEqual('OK');
  })


    test('Update single, pk sk form, form change', async () => {
      let client = new DbClientPostgres(config);

      await client.connect();

      let key_map = {
        pk:{att: "username"},
        sk:{const: "USER"},
        tk:{guid: "820a5bd9-e669-41d4-b917-81212bc184a3"}        // * is flag to calculate guid when not provided
      };

      let form = {
        "username":"update@user.com",
        "displayname":"JChanged",
        "password":"a1A!aaaa"
       };
      //console.log('test update chelate', new Chelate(key_map, form));
      let updateResult = await client.update(new Chelate(key_map, form));
      //console.log('test update ', updateResult);
      client.end();

      expect(updateResult.status).toEqual('200');
      expect(updateResult.msg).toEqual('OK');
    })
    test('Update single, pk sk form, pk change', async () => {
      let client = new DbClientPostgres(config);

      await client.connect();

      let chelate = {
        "pk":"username#update@user.com",
        "sk":"const#USER",
        "form": {
          "username":"updateChange@user.com",
          "displayname":"J",
          "password":"a1A!aaaa"
         }
       };

      console.log('test update chelate', chelate);
      let updateResult = await client.update(chelate);
      console.log('test update ', updateResult);
      client.end();

      expect(updateResult.status).toEqual('200');
      expect(updateResult.msg).toEqual('OK');
    })
    */
//});
