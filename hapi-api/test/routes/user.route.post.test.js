import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../lib/auth/test_token_payload.js';

import { init } from '../../lib/server.js';
import { Password } from '../../lib/auth/password.js';

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
      // Strategy: use guest token to add user
      //           set validation in route route.options.auth
      let username = 'new@user.com';
      let payload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      const res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: token,
            rollback:true
          },
          payload: {
            username: username,
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      //console.log('New User test: ','res',res.result);
      //console.log('test','res',JSON.parse(JSON.stringify(res.result)));
      //console.log('test','res',JSON.parse(JSON.stringify(res.result.insertion.form.password)));

      expect(res.statusCode).toEqual(200);
      expect(res.result.insertion).toBeDefined();
      expect(res.result.insertion.pk).toBeDefined();
      expect(res.result.insertion.sk).toBeDefined();
      expect(res.result.insertion.tk).toBeDefined();
      expect(res.result.insertion.form).toBeDefined();
      expect(res.result.insertion.form.password).not.toBeDefined();
      expect(res.result.insertion.owner).toBeDefined();
      expect(res.result.insertion.active).toBeDefined();
      expect(res.result.insertion.created).toBeDefined();
      expect(res.result.insertion.updated).toBeDefined();

  });

/*
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
*/
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
      let secret = process.env.LB _JWT_SECRET;
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
