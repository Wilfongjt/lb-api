import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
}
import DbClientPoolPostgres from '../../../lib/clients/postgres/db_client_pool_postgres.js';
import DbClientPostgres from '../../../lib/clients/postgres/db_client_postgres.js';

// the pool will emit an error on behalf of any idle clients
// it contains if a backend error or network partition happens

describe('New DbPoolPostgres', () => {
  const config = {
    user: process.env.PGUSER || 'postgres',
    host: 'localhost'|| process.env.PGHOST || 'db',
    database: process.env.PGDATABASE || 'one_db',
    password: process.env.PGPASSWORD || 'mysecretdatabasepassword',
    port: process.env.PGPORT || 5433,
    Client: DbClientPostgres
  };
  // console.log('startup the pool');
  const pool = new DbClientPoolPostgres(config); // warm up the pool

  beforeAll(() => {
    //console.log('start pool');
  });

  afterAll(() => {
    //console.log('end pool');
    pool.end();
  });
  // Initialize
  test('DbPoolPostgres.query', async () => {
      const client = await pool.connect();

      try {
        // call something to see if it works
        const res = await client.query({pk:'testname#connection-test',sk:'const#TEST'});
      } finally {
        // Make sure to release the client before any error handling,
        // just in case the error handling itself throws an error.
        client.release();
      }

  })
});
