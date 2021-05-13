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

  it('/user : User (DELETE), response 200', async () => {
    //console.log('user delete test 1');
      // Goal: Add application user
      // Strategy: use guest token to add user
      //           set validation in route route.options.auth
      //           try to add a record
      //           delete the new record
      // [Insert a record to delete]
      let username = 'delete@user.com';
      let guestTokenPayload = new TestTokenPayload().guest_TokenPayload();
      let secret = process.env.API_JWT_SECRET;
      let guestToken = 'Bearer ' + Jwt.token.generate(guestTokenPayload, secret);
      //console.log('user delete test 2');

      let res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: guestToken
          },
          payload: {
            username: username,
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      //console.log('user delete test 3');
      //console.log('user delete test A result: ','res',res);
      let key = 'xxx.yyy.zzz';
      if (res.result['insertion']) {
        // [Detect error]
        key = res.result.insertion.owner;
      }
      //let key = res.result.insertion.owner;

      let scope = 'api_user'
      let userPayload = new TestTokenPayload().user_TokenPayload(username, key, scope);
      let userToken = 'Bearer ' + Jwt.token.generate(userPayload, secret);
      //console.log('user delete test userToken', userToken);
      //console.log('user delete test key', key);
      //console.log('user delete test username ', username);
      res = await server.inject({
          method: 'delete',
          url: '/user',
          headers: {
            authorization: userToken
          },
          payload: {
            pk: username
          }
      });
      //console.log('user delete 4');

      //console.log('Delete User test B results: ','res',res);

      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');

      expect(res.result.deletion).toBeDefined();
      expect(res.result.deletion.pk).toBeDefined();
      expect(res.result.deletion.sk).toBeDefined();
      expect(res.result.deletion.tk).toBeDefined();
      expect(res.result.deletion.form).toBeDefined();
      expect(res.result.deletion.form.password).not.toBeDefined();
      expect(res.result.deletion.owner).toBeDefined();
      expect(res.result.deletion.active).toBeDefined();
      expect(res.result.deletion.created).toBeDefined();
      expect(res.result.deletion.updated).toBeDefined();

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
