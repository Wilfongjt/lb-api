import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
}
import Const from '../../../lib/constants/consts.js';
import DataTypes from '../../../lib/constants/data_types.js';

import DbClientPostgres from '../../../lib/clients/postgres/db_client_postgres.js';

import { ChelateUser } from '../../../lib/chelates/chelate_user.js';
import { CriteriaBest } from '../../../lib/clients/criteria.js';

const { Pool } = require('pg');
const pool = new Pool();

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

  test('new DbClientPostgres', () => {
    expect(new DbClientPostgres(config)).toBeDefined();
  })

  test('client.connect()', () => {
    let client = new DbClientPostgres(config);

    expect(client.connect()).toBeDefined();
    client.end();
  })

  test('Select All, BAD client.query(\"\")', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    let queryResult = await client.query('');

    expect(queryResult.selection.length).toEqual(0);

    client.end();
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
    //console.log('Select many queryResult',queryResult);

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })

  test('Select single,  client.query({"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"sk":"const#USER", "tk":"guid#620a5bd9-e669-41d4-b917-81212bc184a3"};

    let queryResult = await client.query(criteria);
    //console.log('Select single queryResult',queryResult);

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

  test('Select many,  client.query({"xk":"woden", "yk":"woden@citizenlabs.org"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    //const criteria = {"xk":"woden", "yk":"woden@citizenlabs.org"};
    let criteria = new CriteriaBest({xk:"woden", yk:"woden@citizenlabs.org"});

    let queryResult = await client.query(criteria);
    //console.log('Select queryResult',JSON.stringify(queryResult));

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })

  // Insert
  // Update
  // Delete
  /*
  test('Delete single,  client.query({"sk":"const#USER", "sk":"*"})', async () => {
    let client = new DbClientPostgres(config);
    await client.connect();
    const criteria = {"sk":"const#USER", "tk":"*"};

    let queryResult = await client.delete(criteria);
    //console.log('Select many queryResult',JSON.stringify(queryResult));

    client.end();

    expect(queryResult.selection.length).not.toEqual(0);

  })
  */
});
