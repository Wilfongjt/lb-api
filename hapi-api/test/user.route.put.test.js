import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js';
import Jwt from '@hapi/jwt';
import TestData from './test_data.js';
import { Password } from '../lib/password.js';


describe('User Route ', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

  // Attempt Add User with nonGuest token

  it('/user : UPDATE User (PUT), response 200', async () => {
    // Goal: Update application user
    // Strategy: a user can only update their own
    //           set validation in route route.options.auth
      let user_name = 'existing@user.com';
      let id = '520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope = ['app'];
      let token_payload = new TestData().user_TokenPayload(user_name,id,scope);
      //console.log('test','token_payload',token_payload);
      // set up token
      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(token_payload, secret);

      // update a record
      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {

            sk:'const#USER',
            tk:`guid#${id}`,
            form: {
              username: `${user_name}`,
              displayname: 'J',
              password: 'b1B!bbbb'
            }
          }
      });
      //console.log('res.result', res.result);
      //console.log('res.request.payload', res.request.payload);

      expect(res.statusCode).toEqual(200);
      expect(res.result.criteria).toBeDefined();
      expect(res.result.updates).toBeDefined();


  });

});
