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

describe('User DELETE, GET, PUT and POST Routes ', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

//  _____  ______ _      ______ _______ ______
// |  __ \|  ____| |    |  ____|__   __|  ____|
// | |  | | |__  | |    | |__     | |  | |__
// | |  | |  __| | |    |  __|    | |  |  __|
// | |__| | |____| |____| |____   | |  | |____
// |_____/|______|______|______|  |_|  |______|




  it('/user : User (DELETE), response 200', async () => {
    //console.log('user delete test 1');
      // Goal: Delete user's user record
      // Strategy: use guest token to add user
      //           set validation in route route.options.auth
      //           try to add a record
      //           delete the new record

      let username = 'delete@user.com';
      let displayname = 'J';
      let secret = process.env.API_JWT_SECRET;
      let primaryKey = username;
      let userKey = 'duckduckgoose';
      let scope = 'api_user';
      let password = 'a1AA!aaaa';

      let userPayload = new TestTokenPayload()
                              .user_TokenPayload(
                                username,
                                'guid#%1'.replace('%1',userKey),
                                scope
                              );

      let userToken = 'Bearer ' + Jwt.token.generate(userPayload, secret);
      // [Define a test form]
      let test_form = {
        user_key: userKey,
        scope: scope,
        form: {
          username: username,
          displayname: displayname,
          password: password
        }
      };

      //console.log('guestPayload', guestPayload);
      //console.log('userPayload', userPayload);

      // [Delete a record]
      let res = await server.inject({
          method: 'delete',
          url: '/user',
          headers: {
            authorization: userToken,
            test: test_form
          },
          payload: {
            pk: username
          }
      });

      //console.log('test res',res.result);

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


  //   _____ ______ _______
  //  / ____|  ____|__   __|
  // | |  __| |__     | |
  // | | |_ |  __|    | |
  // | |__| | |____   | |
  //  \_____|______|  |_|


  it('/user : guest_token cannot GET user, Hapi 403', async () => {
      //console.log('TEST user GET test 1');
      // Goal: Add application user
      // Strategy: let hapi throw the api_guest exception
      //           set validation in route route.options.auth
      //           pass a temporary record in header

      let username = 'guest@user.com';
      let key = 'guest520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope ='api_guest';
      let guestTokenPayload = new TestTokenPayload()
                                    .guest_TokenPayload();
      let secret = process.env.API_JWT_SECRET;
      let guestToken = 'Bearer ' + Jwt.token.generate(guestTokenPayload, secret);

      let test_form = {
        username: username,
        displayname: 'J',
        password: 'a1A!aaaa'
      };

      let res = await server.inject({
          method: 'get',
          url: '/user/%s'.replace('%s', username),
          headers: {
            'authorization': guestToken,
            test: test_form
          }
      });
      //console.log('TEST /user GET res', res);
      //console.log('TEST /user GET res.statusCode', res.statusCode);
      //console.log('TEST /user GET res.results', res.result);
      // Hapi statusCode
      expect(res.result.statusCode).toEqual(403);

  });
  it('/user : user_token can GET user, 200', async () => {
      //console.log('TEST user GET test 1');
      // Goal: Add application user
      // Strategy: use guest token to add user
      //           set validation in route route.options.auth
      //           pass a temporary record in header
      let username = 'user@user.com';
      let key = 'user520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope ='api_user';
      let userTokenPayload = new TestTokenPayload()
                                   .user_TokenPayload(
                                     username,
                                     `guid#${key}`,
                                     scope);
      let secret = process.env.API_JWT_SECRET;
      let userToken = 'Bearer ' + Jwt.token.generate(userTokenPayload, secret);

      let test_form = {
        username: username,
        displayname: 'J',
        password: 'a1A!aaaa'
      };

      let res = await server.inject({
          method: 'get',
          url: '/user/%s'.replace('%s', username),
          headers: {
            'authorization': userToken,
            test: test_form
          }
      });
      //console.log('TEST /user GET res', res);
      //console.log('TEST /user GET res.statusCode', res.statusCode);
      //console.log('TEST /user GET res.results', res.result);
      expect(res.result.status).toEqual('200');

      expect(res.result.selection[0]).toBeDefined();
      expect(res.result.selection[0].pk).toBeDefined();
      expect(res.result.selection[0].sk).toBeDefined();
      expect(res.result.selection[0].tk).toBeDefined();
      expect(res.result.selection[0].form).toBeDefined();
      expect(res.result.selection[0].form.password).not.toBeDefined();
      expect(res.result.selection[0].owner).toBeDefined();
      expect(res.result.selection[0].active).toBeDefined();
      expect(res.result.selection[0].created).toBeDefined();
      expect(res.result.selection[0].updated).toBeDefined();

  });

  it('/user : admin_token can GET user, 200', async () => {
      //console.log('TEST user GET test 1');
      // Goal: Add application user
      // Strategy: use guest token to add user
      //           set validation in route route.options.auth
      //           pass a temporary record in header

      let username = 'admin@user.com';
      let key = 'admin520a5bd9-e669-41d4-b917-81212bc184a3';
      let scope ='api_admin';
      let adminTokenPayload = new TestTokenPayload()
                                    .admin_TokenPayload(
                                      username,
                                      `guid#${key}`,
                                      scope);
      let secret = process.env.API_JWT_SECRET;
      let adminToken = 'Bearer ' + Jwt.token.generate(adminTokenPayload, secret);

      let test_form = {
        username: username,
        displayname: 'J',
        password: 'a1A!aaaa'
      };

      let res = await server.inject({
          method: 'get',
          url: '/user/%s'.replace('%s', username),
          headers: {
            'authorization': adminToken,
            test: test_form
          }
      });
      //console.log('TEST /user GET res', res);
      //console.log('TEST /user GET res.statusCode', res.statusCode);
      //console.log('TEST /user GET res.results', res.result);
      expect(res.result.status).toEqual('200');

      expect(res.result.selection[0]).toBeDefined();
      expect(res.result.selection[0].pk).toBeDefined();
      expect(res.result.selection[0].sk).toBeDefined();
      expect(res.result.selection[0].tk).toBeDefined();
      expect(res.result.selection[0].form).toBeDefined();
      expect(res.result.selection[0].form.password).not.toBeDefined();
      expect(res.result.selection[0].owner).toBeDefined();
      expect(res.result.selection[0].active).toBeDefined();
      expect(res.result.selection[0].created).toBeDefined();
      expect(res.result.selection[0].updated).toBeDefined();

  });

    //  _____   ____   _____ _______
    // |  __ \ / __ \ / ____|__   __|
    // | |__) | |  | | (___    | |
    // |  ___/| |  | |\___ \   | |
    // | |    | |__| |____) |  | |
    // |_|     \____/|_____/   |_|



      it('/user : guest_token cannot POST NEW User, Hapi 403', async () => {
          // Goal: Stop guest_token from adding a user
          // Strategy: configure in route's options.auth.access.scope and let hapi throw the exception
          //

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
          //console.log('New User test: ','res',res);
          //console.log('New User test: ','res.result',res.result);

          expect(res.statusCode).toEqual(403);

      });

        it('/user : user_token cannot POST NEW User, Hapi 403', async () => {
            // Goal: Add application user
            // Strategy: configure in route's options.auth.access.scope and let hapi throw the exception
            //
            let username = 'new@user.com';
            let key='fakekey';
            let scope='api_user';
            let payload = new TestTokenPayload()
                                .user_TokenPayload(
                                  username,
                                  `guid#${key}`,
                                  scope);
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
            //console.log('New User test: ','res',res);
            //console.log('New User test: ','res.result',res.result);

            expect(res.statusCode).toEqual(403);

        });


      it('/user : admin_token can POST NEW User, 200', async () => {
          // Goal: Add application user
          // Strategy: configure in route's options.auth.access.scope and let hapi throw the exception
          //
          let username = 'new@user.com';
          let key='fakekey';
          let scope='api_user';
          let payload = new TestTokenPayload()
                              .admin_TokenPayload(
                                username,
                                `guid#${key}`,
                                scope);
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
          //console.log('New User test: ','res',res);
          //console.log('New User test: ','res.result',res.result);
          expect(res.statusCode).toEqual(200);

      });
  //  _____  _    _ _______
  // |  __ \| |  | |__   __|
  // | |__) | |  | |  | |
  // |  ___/| |  | |  | |
  // | |    | |__| |  | |
  // |_|     \____/   |_|

  it('/user : user_token can PUT user.displayname change, 200', async () => {
      // Goal: Update application user
      // Strategy: a user can only update their own
      //           set validation in route route.options.auth
      let user_name = 'update@user.com';
      let user_name_new = 'updated@user.com';
      let displayname_new = 'K';
      let password_new = 'a1A!aaaa';
      //let key = 'update520a5bd9-e669-41d4-b917-81212bc184a3';
      let userKey = 'duckduckgoose';
      let scope = 'api_user';
      let user_token_payload = new TestTokenPayload()
                                      .user_TokenPayload(
                                        user_name,
                                        `guid#${userKey}`,
                                        scope);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(user_token_payload, secret);
      let payload_new = {
        pk: `username#${user_name}`,
        form: {
          username: user_name_new,
          displayname: displayname_new,
          password: password_new
        }
      };

      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token,
            test: {
              user_key: userKey,
              scope: scope,
              form:{
                username: user_name,
                displayname: "J",
                password: "a1Aaaaa"
              }
            }
          },
          payload: payload_new
      });
      //console.log('put res', res);
      //console.log('put res.result', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');
      expect(res.result.updation.pk).toEqual(`username#${user_name_new}`);
      expect(res.result.updation.form.username).toEqual(user_name_new);
      expect(res.result.updation.form.displayname).toEqual(displayname_new);
      expect(res.result.updation.form.password).not.toBeDefined();
  });

  // /user : user_token can PUT password, 200
  it('/user : user_token can PUT user.password change, 200', async () => {
      // Goal: Update application user
      // Strategy: a user can only update their own
      //           set validation in route route.options.auth
      let user_name = 'update@user.com';
      let user_name_new = 'updated@user.com';
      let displayname_new = 'J';
      let password_new = 'b1B!bbbb';
      //let key = 'updatea520a5bd9-e669-41d4-b917-81212bc184a3';
      let userKey = 'duckduckgoose';
      let scope = 'api_user';
      let user_token_payload = new TestTokenPayload()
                                     .user_TokenPayload(
                                       user_name,
                                       `guid#${userKey}`,
                                       scope);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(user_token_payload, secret);
      let payload_new = {
        pk: `username#${user_name}`,
        form: {
          username: user_name_new,
          displayname: displayname_new,
          password: password_new
        }
      };

      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token,
            test: {
              user_key: userKey,
              scope: scope,
              form:{
                username: user_name,
                displayname: "J",
                password: "a1A!aaaa"
              }
            }
          },
          payload:  payload_new
      });
      //console.log('res', res);
      //console.log('res.result', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');
      expect(res.result.updation.pk).toEqual(`username#${user_name_new}`);
      expect(res.result.updation.form.username).toEqual(user_name_new);
      expect(res.result.updation.form.displayname).toEqual(displayname_new);
      expect(res.result.updation.form.password).not.toBeDefined();
  });
  // /user :  user_token can PUT primary key, 200
  it('/user : user_token can PUT user primary key change, 200', async () => {
      // Goal: Update application user
      // Strategy: a user can only update their own
      //           set validation in route route.options.auth
      let user_name = 'update@user.com';
      let user_name_new = 'updated1@user.com';
      let displayname_new = 'J';
      let password_new = 'a1Aaaaa';
      //let key = 'updatea520a5bd9-e669-41d4-b917-81212bc184a3';
      let userKey = 'duckduckgoose';
      let scope = 'api_user';
      let user_token_payload = new TestTokenPayload()
                                     .user_TokenPayload(
                                       user_name,
                                       `guid#${userKey}`,
                                       scope);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(user_token_payload, secret);
      let payload_new = {
        pk: `username#${user_name}`,
        form: {
          username: user_name_new,
          displayname: displayname_new,
          password: password_new
        }
      };

      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token,
            test: {
              user_key: userKey,
              scope: scope,
              form:{
                username: user_name,
                displayname: "J",
                password: "a1Aaaaa"
              }
            }
          },
          payload: payload_new
      });
      //console.log('res', res);
      //console.log('res.result', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');
      expect(res.result.updation.pk).toEqual(`username#${user_name_new}`);
      expect(res.result.updation.form.username).toEqual(user_name_new);
      expect(res.result.updation.form.displayname).toEqual(displayname_new);
      expect(res.result.updation.form.password).not.toBeDefined();
  });

  it('/user : user_token can PUT user displayname, password, and primary key changes all at once, 200', async () => {
      // Goal: Update application user
      // Strategy: a user can only update their own
      //           set validation in route route.options.auth
      let user_name = 'update@user.com';
      let user_name_new = 'updated@user.com';
      let displayname_new = 'K';
      let password_new = 'b1B!bbbb';
      //let key = 'updatea520a5bd9-e669-41d4-b917-81212bc184a3';
      let userKey = 'duckduckgoose';
      let scope = 'api_user';
      let user_token_payload = new TestTokenPayload()
                                     .user_TokenPayload(
                                       user_name,
                                       `guid#${userKey}`,
                                       scope);
      // set up token
      let secret = process.env.API_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(user_token_payload, secret);
      let payload_new = {
        pk: `username#${user_name}`,
        form: {
          username: user_name_new,
          displayname: displayname_new,
          password: password_new
        }
      };

      const res = await server.inject({
          method: 'put',
          url: '/user',
          headers: {
            authorization: token,
            test: {
              user_key: userKey,
              scope: scope,
              form:{
                username: user_name,
                displayname: "J",
                password: "a1Aaaaa"
              }
            }
          },
          payload: payload_new
      });
      //console.log('res', res);
      //console.log('res.result', res.result);
      expect(res.statusCode).toEqual(200);
      expect(res.result.status).toEqual('200');
      expect(res.result.updation.pk).toEqual(`username#${user_name_new}`);
      expect(res.result.updation.form.username).toEqual(user_name_new);
      expect(res.result.updation.form.displayname).toEqual(displayname_new);
      expect(res.result.updation.form.password).not.toBeDefined();
  });


});
