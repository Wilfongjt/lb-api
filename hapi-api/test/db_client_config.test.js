import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import DbClientConfig from '../lib/db_client_config.js';

describe('DbClientConfig', () => {
  test('new DbClientConfig', () => {
    //const config = new DbClientConfig();
    expect(new DbClientConfig()).toBeDefined();
  })
});
