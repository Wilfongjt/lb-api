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


  // signup
  it('/signup : Signup (POST), response 200', async () => {
      // Goal: Create an application user
      // Strategy: only guest token can signin
      //           set validation in route route.options.auth
      let username = 'new@user.com';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      const res = await server.inject({
          method: 'post',
          url: '/signup',
          headers: {
            authorization: token,
            rollback: true
          },
          payload: {
            username: username,
            password: 'a1A!aaaa',
            displayname: 'J'
          }
      });
      //console.log('test','signup', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual("200");
      //expect(res.result.token).toBeDefined();
  });
  // signin
  it('/signin : Signin (POST), response 200', async () => {
      // Goal: Singin  application user
      // Strategy: only guest token can signin
      //           set validation in route route.options.auth
      //let username = 'signin@user.com';
      let username = 'existing2@user.com';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      //console.log('TEST signin A signup res1.result ', res1.result);
      //console.log('TEST signin username ', username);
      //console.log('TEST signin ',);
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

      //console.log('TEST signin B res.result ', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');

      expect(res.result.token).toBeDefined();
  });
});
