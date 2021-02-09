import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}

import { init } from '../../lib/server.js';
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../lib/auth/test_token_payload.js';

describe('User Route ', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

  // signin
  it('/signin : Signin (POST), response 200', async () => {
      // Goal: Singin  application user
      // Strategy: only guest token can signin
      //           set validation in route route.options.auth
      let username = 'existing@user.com';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      const res = await server.inject({
          method: 'post',
          url: '/signin',
          headers: {
            authorization: token
          },
          payload: {
            username: username,
            password: 'a1A!aaaa'
          }
      });
      //console.log('test','signin', res);
      expect(res.statusCode).toEqual(200);
      expect(res.result.credentials.password).not.toBeDefined();
      expect(res.result.authentication).toBeDefined();

  });

});
