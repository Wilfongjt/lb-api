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



  it('Restricted /restricted responds with 200', async () => {
    // guest token required for restricted
    let token_payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.LB_JWT_SECRET;
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
    let secret = process.env.LB_JWT_SECRET;
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
  it('/user POST, responds with JSON', async () => {
    // guest token required for user POST

    let payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.LB_JWT_SECRET;
    let token = 'Bearer ' + Jwt.token.generate(payload, secret);

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
      console.log('/user res.result', res.result);
      expect(res.result.status).toEqual('200');
      expect(res.result.msg).toEqual('OK');


  });

  // SIGNIN
  /*
  it('Signin fail /signin, responds with ', async () => {
    // guest token required for GET
    // pass form payload in headers for GET

    let payload = new TestTokenPayload().guest_TokenPayload();
    let secret = process.env.LB_JWT_SECRET;
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
