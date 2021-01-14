import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js'
init();

describe('GET /', () => {
  let server;

  beforeEach(async () => {
        server = await init();
    });

  afterEach(async () => {
      await server.stop();
    });

  it('route /, responds with 200', async () => {
          const res = await server.inject({
              method: 'get',
              url: '/'
          });
          // console.log('res', res);
          expect(res.statusCode).toEqual(200);
      });
});
