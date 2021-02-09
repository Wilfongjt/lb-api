import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js';
import Jwt from '@hapi/jwt';
import TestTokenPayload from './test_data.js';
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

  it('/user : NEW User (POST), response 200', async () => {
      // Goal: Add application user
      // Strategy: only guest token can add user
      //           set validation in route route.options.auth
      let username = 'newr@user.com';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      const res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {
            username: username,
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      //console.log('test','res',res);
      //console.log('test','res',JSON.parse(JSON.stringify(res.result)));
      //console.log('test','res',JSON.parse(JSON.stringify(res.result.insertion.form.password)));

      expect(res.statusCode).toEqual(200);
      expect(res.result.insertion).toBeDefined();
      expect(res.result.insertion.form.password).toBeDefined();
      expect(res.result.insertion.form.password.hash).toBeDefined();
      expect(res.result.insertion.form.password.salt).toBeDefined();
      expect(new Password().verify('a1A!aaaa',res.result.insertion.form.password)).toBeTruthy();

      //console.log('test','/user','res.result.insertion', res.result.insertion);
      //expect(res.result.).toBeDefined();
  });

  // Attempt Add User with nonGuest token
  it('/user : NEW User (POST), Restricted Access, response 401', async () => {
      // Goal: Add application user
      // Strategy: only guest token can add user
      //           set validation in route route.options.auth
      let username = 'newr@user.com';
      //let fake_id = 'iamafakeid';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = 'fake-secret';
      // make fake token by changing the secret to "fakesecret"
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      const res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {
            username: username,
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      expect(res.statusCode).toEqual(401);
      expect(res.result.error).toBeDefined();

  });

  // Attempt Add User with nonGuest token
/*
  it('/user : UPDATE User (PUT), response 200', async () => {
    // Goal: Add application user
    // Strategy: only guest token can add user
    //           set validation in route route.options.auth
      let username = 'existing@user.com';
      let id = '520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope = ['app'];
      let token_payload = new TestTokenPayload().user_TokenPayload(username,id,scope);
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
            sk:'USER',
            tk:id,
            form: {
              username: username,
              displayname: 'J',
              password: 'b1B!bbbb'
            }
          }
      });

      expect(res.statusCode).toEqual(200);
      expect(res.result.criteria).toBeDefined();
      expect(res.result.updates).toBeDefined();
  });
*/
});
