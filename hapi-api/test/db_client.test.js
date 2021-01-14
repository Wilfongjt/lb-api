import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import DbClient from '../lib/db_client.js';

describe('DbClient', () => {
  // Initialize
  test('new DbClient', () => {
    //const config = new DbClientConfig();
    expect(new DbClient()).toBeDefined();
  })
  // Insert
  // Update
  // Delete

});
