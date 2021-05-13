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

  // Attempt Add User with nonGuest token
// whate is sql function expecting ... token, pk, form
// can form be just a form without pk sk or tk ... yes
  it('/user : UPDATE User (PUT), change password ,response 200', async () => {
    // Goal: Update application user
    // Strategy: a user can only update their own
    //           set validation in route route.options.auth
      let user_name = 'existing@user.com';
      let id = '520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope = 'api_user';
      let token_payload = new TestTokenPayload().user_TokenPayload(user_name,id,scope);
      //console.log('test','token_payload',token_payload);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(token_payload, secret);
      let payload = {
        pk: `username#${user_name}`,
        form: {
          username: `${user_name}`,
          displayname: 'J',
          password: 'b1B!bbbb'
        }
      };
      //console.log('user route put token ', token);
      //console.log('user route put payload ', payload );
      // update a record
      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: payload
      });
      //console.log('res', res);

      //console.log('res.result', res.result);
      //console.log('res.request.payload', res.request.payload);
      expect(res.statusCode).toEqual(200);

      expect(res.result.status).toEqual('200');
      //expect(res.result.criteria).toBeDefined();
      expect(res.result.updation).toBeDefined();
      expect(res.result.updation.pk).toEqual(`username#${user_name}`);


  });
  // Change PK
  it('/user : UPDATE User (PUT), change Primary Key (pk) ,response 200', async () => {
    // Goal: Update application user
    // Strategy: a user can only update their own
    //           set validation in route route.options.auth
      let user_name = 'existing@user.com';
      let change_user_name = 'change@user.com'
      let id = '520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope = 'api_user';
      let token_payload = new TestTokenPayload().user_TokenPayload(user_name,id,scope);
      //console.log('test','token_payload',token_payload);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(token_payload, secret);
      let displayname = 'K';
      //console.log('user route put token ', token);
      //console.log('user route put payload ', payload );
      // update a record
      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token,
            rollback:true
          },
          payload: {
            pk: `username#${user_name}`,
            form: {
              username: `${change_user_name}`,
              displayname: displayname,
              password: 'b1B!bbbb'
            }
          }
      });
      //console.log('res', res);

      //console.log('res.result', res.result);
      //console.log('res.request.payload', res.request.payload);
      expect(res.statusCode).toEqual(200);

      expect(res.result.status).toEqual('200');
      //expect(res.result.criteria).toBeDefined();
      expect(res.result.updation).toBeDefined();
      expect(res.result.updation.pk).toEqual(`username#${change_user_name}`);
      expect(res.result.updation.form).toBeDefined();
      expect(res.result.updation.form.displayname).toEqual(displayname);


  });


});
