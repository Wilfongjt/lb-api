import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}
/* ISSUES

*/
import TestTokenPayload from '../../../../lib/auth/test_token_payload.js';

import Jwt from '@hapi/jwt';

//import { init } from '../../../../lib/server.js'
import { HapiPgRouteHelper } from '../../../../lib/routes/postgres/helpers/hapi_pg_route_helper.js';
import { Client } from 'pg';

describe('HapiPgRouteHelper New', () => {
  /*
  const config = {
    user: process.env.PGUSER || 'postgres',
    host: 'localhost'|| process.env.PGHOST || 'db',
    database: process.env.PGDATABASE || 'one_db',
    password: process.env.PGPASSWORD || 'mysecretdatabasepassword',
    port: process.env.PGPORT || 5433,
    guest_token: process.env.API_GUEST_TOKEN,
    Client: Client
  };
  */
  //const pool = new HapiPgPoolHelper(config);
  //const pool = new Pool(config);

  beforeAll(() => {

  });

  afterAll(() => {
    //pool.end();
  });
  // Initialize
  test('HapiPgRouteHelper', () => {
    let hapiPgPoolHelper = new HapiPgRouteHelper();
    // New from Form
    expect(hapiPgPoolHelper).toBeDefined();
    expect(hapiPgPoolHelper.route_post()).toBeDefined();
    expect(hapiPgPoolHelper.route_get()).toBeDefined();
    expect(hapiPgPoolHelper.route_put()).toBeDefined();
    expect(hapiPgPoolHelper.route_delete()).toBeDefined();


  })


});
