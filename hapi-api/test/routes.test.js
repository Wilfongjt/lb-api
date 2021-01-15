import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js'
import Jwt from '@hapi/jwt';

describe('GET /restricted', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

  it('No authorization /, responds with 200', async () => {
    // Goal: Allow unauthenticated access to an API route
    // Strategy: Least Privileges
    //           Lock down all routes
    //           and then open a route by configuring route with options: {auth: false}
    const res = await server.inject({
        method: 'get',
        url: '/'
    });

    expect(res.statusCode).toEqual(200);
  });

  it('Unauthorized token on route /restricted, responds with 401', async () => {
      // Goal: Enforce authenticated access to an API route
      // Strategy: reject counterfit tokens
      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: 'Bearer in.valid.token'
          }
      });

      expect(res.statusCode).toEqual(401);
  });


  it('Bad token claim value on route /restricted, responds with 401', async () => {
    // Goal: Enforce authenticated access to an API route
    // Strategy: Reject tokens with wrong claim values
    //           See list of claims in lib/server.js strategy(), verify for required claims
      let payload = {
          aud: 'api-client',
          iss: 'wrongclaimvalue',
          sub: false
      };

      let secret = process.env.LB_JWT_SECRET;

      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      //console.log('token', token);

      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: token
          }
      });

      expect(res.statusCode).toEqual(401);
  });

  it('Missing token claim on route /restricted, responds with 401', async () => {
    // Goal: Enforce authenticated access to an API route
    // Strategy: Reject tokens with missing claims ... hapi requires aud, iss, sub
    //           See list of claims in lib/server.js strategy(), verify for required claims
      let payload = {

          iss: 'lyttlebit',
          sub: false

      };

      let secret = process.env.LB_JWT_SECRET;

      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      //console.log('token', token);

      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: token
          }
      });

      expect(res.statusCode).toEqual(401);
  });

  it('Bad token secret on route /restricted, responds with 401', async () => {
      // Goal: call api with application JWT app-token
      // Strategy: reject when token is made with wrong password/secret
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false
      };

      let secret = 'the.wrong.password';

      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: token
          }
      });

      expect(res.statusCode).toEqual(401);
  });

  it('Authorized token on route /restricted, responds with 200', async () => {
    // Goal: call api with application JWT app-token
    // Strategy:
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false
      };

      let secret = process.env.LB_JWT_SECRET;

      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: token
          }
      });
      //console.log('statusMessage', res.statusMessage);
      expect(res.statusCode).toEqual(200);
  });


});
