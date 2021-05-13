import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}
import TestTokenPayload from '../../lib/auth/test_token_payload.js';

import Jwt from '@hapi/jwt';

import { init } from '../../lib/server.js'


describe('Server Tests', () => {
  let server = null;

  beforeAll(async () => {
    //console.log('test server init');
        server = await init();
    });

  afterAll(async () => {
    // delete from one where pk is "test@user.com"
    //console.log('test server stop');
      await server.stop();
    });

  it('Registered paths responds with 404', async () => {
    // no token required for root
    let paths = [];
    for(let i of server.table()) {
      paths.push(i.path)
    };
    //console.log('paths', paths);
    let path = '/';
    expect(paths.find(element => element === '/')).toBeTruthy();
    expect(paths.find(element => element === '/restricted')).toBeTruthy();
    expect(paths.find(element => element === '/time')).toBeTruthy();

  });


  it('Root / responds with 200', async () => {
    // no token required for root
    const res = await server.inject({
        method: 'GET',
        url: '/'
    });
    //console.log('res', res.result);
    expect(res.result.status).toEqual('200');
    expect(res.result.msg).toEqual('OK');
  });



  it('Restricted /restricted 200', async () => {
    // guest token required for restricted
    let token_payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.API_JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(token_payload, secret);

    const res = await server.inject({
        method: 'get',
        url: '/restricted',
        headers: {
          authorization: token
        }
    });
    //console.log('res', res.result);
    expect(res.result.status).toEqual('200');
    expect(res.result.msg).toEqual('OK');
  });

  it('Connect /time, responds with 200', async () => {
    // guest token required for GET
    // pass form payload in headers for GET

    let token_payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.API_JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(token_payload, secret);

      const res = await server.inject({
          method: 'GET',
          url: '/time',
          headers: {
            authorization: token
          }
      });
      //console.log('res.result', res.result);
      expect(res.result.status).toEqual('200');
      expect(res.result.msg).toEqual('OK');
      expect(res.result.time).toBeDefined();
      expect(res.result.zone).toBeDefined();

  });
  // User
  /*
  it('/user POST, 200 OK', async () => {
    // guest token required for user POST

    let payload = new TestTokenPayload().guest_TokenPayload();
    //let payload = new TestTokenPayload().user_TokenPayload('username@user.com', 'id-xxx', 'api_user');
    //let payload = new TestTokenPayload().user_TokenPayload('username@user.com', 'api_user');
    console.log('POST payload ', payload);
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);
    //console.log('user token ', token);
    const res = await server.inject({
          method: 'POST',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {username:"insert@user.com",
                    displayname: "test",
                    password:"a1A!aaaa"}
    });
    //console.log('token ', token);
    console.log('/user res.result', res.result);
    expect(res.result.status).toEqual('200');
    expect(res.result.msg).toEqual('OK');
  });
  */
  /*
  it('/user POST, 409 Duplicate', async () => {
    // guest token required for user POST

    let payload = new TestTokenPayload().guest_TokenPayload();
    //let payload = new TestTokenPayload().user_TokenPayload('username@user.com', 'id-xxx', 'api_user');
    //let payload = new TestTokenPayload().user_TokenPayload('username@user.com', 'api_user');
    //console.log('payload ', payload);
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);
    //console.log('user token ', token);
    const res = await server.inject({
          method: 'POST',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {username:"insert@user.com",
                    displayname: "test",
                    password:"a1A!aaaa"}
    });
    //console.log('token ', token);
    //console.log('/user res.result', res.result);
    expect(res.result.status).toEqual('409');
    expect(res.result.msg).toEqual('Duplicate');
  });
  */
/*
  it('/user select, 200 OK', async () => {
    // /user DELETE is dependent on /user POST
    // this is a admin function
    //let payload = new TestTokenPayload().user_TokenPayload('insert@user.com', 'xxx','api_user');
    let payload = new TestTokenPayload().admin_TokenPayload('insert@user.com', '0');
    //console.log('payload ', payload);
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);
    //console.log('user token ', token);
    const res = await server.inject({
          method: 'GET',
          url: '/user',
          headers: {
            authorization: token,
            payload: { // pass payload in header because header doesnt get logged
              criteria: {
                pk:'username#insert@user.com',
                sk:'const#USER'
              },
              options: {}
            }
          }
    });
    expect(res.result.status).toEqual('200');
    expect(res.result.msg).toEqual('OK');
  });
*/
/*

  it('/user select, 403 Forbidden', async () => {
    // /user DELETE is dependent on /user POST
    // this is a admin function
    //let payload = new TestTokenPayload().user_TokenPayload('insert@user.com', 'xxx','api_user');
    let payload = new TestTokenPayload().admin_TokenPayload('insert@user.com', 'xxx');

    //console.log('payload ', payload);
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);
    //console.log('user token ', token);
    const res = await server.inject({
          method: 'GET',
          url: '/user',
          headers: {
            authorization: token,
            payload: {
              criteria: {
                pk:'username#insert@user.com',
                sk:'const#USER'
              },
              options: {}
            }
          }
    });
    expect(res.result.status).toEqual('403');
    expect(res.result.msg).toEqual('Forbidden');
  });

*/
/*
  it('/user DELETE, 200 ', async () => {
    // /user DELETE is dependent on /user POST

    let payload = new TestTokenPayload().user_TokenPayload('insert@user.com', 'xxx','api_user');
    //console.log('payload ', payload);
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);
    //console.log('user token ', token);
    const res = await server.inject({
          method: 'DELETE',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {
            pk:'username#insert@user.com',
            sk:'const#USER'
          }
    });
    expect(res.result.status).toEqual('200');
    expect(res.result.msg).toEqual('OK');
  });
*/

  // SIGNIN
  /*
  it('Signin fail /signin, responds with ', async () => {
    // guest token required for GET
    // pass form payload in headers for GET

    let payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.LB _JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      const res = await server.inject({
          method: 'POST',
          url: '/signin',
          headers: {
            authorization: token
          },
          payload: {username:"unknown",
                    password:"a1A!aaaa"}
      });
      //console.log('res.result', res);
      expect(res.result.status).toEqual('404');
      expect(res.result.msg).toEqual('Not Found');
      //expect(res.result.error).toBeDefined();
      //expect(res.result.zone).toBeDefined();

  });
*/
// Bad Token test

// insert
// update
// select
// delete

// plugin for authentication ?
// Happ Authnentication research


});
