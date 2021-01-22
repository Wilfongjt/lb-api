import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js'
import Jwt from '@hapi/jwt';

describe('Routes ', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

  it('Token: No authorization /, responds with 200', async () => {
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

  it('Token: Unauthorized token on route /restricted, responds with 401', async () => {
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


  it('Token: Bad token claim value on route /restricted, responds with 401', async () => {
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

  it('Token: Missing token claim on route /restricted, responds with 401', async () => {
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

  it('Token: Bad token secret on route /restricted, responds with 401', async () => {
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

  it('Token: Authorized token on route /restricted, responds with 200', async () => {
    // Goal: call api with application JWT app-token
    // Strategy: configure route validate to check for user and scope
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false,
          user: 'guest',   // check existance in validate
          scope: ['guest'] // check existance in validate
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

      expect(res.statusCode).toEqual(200);
  });



  it('Token: Missing user in token on route /restricted, responds with 401', async () => {
    // Goal: call api with application JWT app-token
    // Strategy: create a guest token and
    //           remove guest
    //           pass it to restricted route
    //           expect 401 exception
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false,
          // user: 'guest',
          scope: ['guest'] // check existance in validate
      };
      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);
      // evaluate
      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: token
          }
      });

      expect(res.statusCode).toEqual(401);
  });



  it('Token: Missing scope in token on route /restricted, responds with 401', async () => {
    // Goal: call api with application JWT app-token
    // Strategy: create a guest token and
    //           remove scope
    //           pass it to restricted route
    //           expect 401 exception
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false,
          user: 'guest'
          //scope: ['guest'] // check existance in validate
      };
      let secret = process.env.LB_JWT_SECRET;
      // evaluate
      const res = await server.inject({
          method: 'get',
          url: '/restricted',
          headers: {
            authorization: 'Bearer ' + Jwt.token.generate(payload, secret)
          }
      });

      expect(res.statusCode).toEqual(401);
  });


  it('Token: Add User with Guest token on route /user, responds with 200', async () => {
    // Goal: Add application user
    // Strategy: only guest token can add user
    //           set validation in route route.options.auth
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false,
          user: 'guest',
          scope: ['guest']
      };

      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      const res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {
            username: 'J W',
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      console.log('message', res.statusMessage);
      expect(res.statusCode).toEqual(200);
  });

  // Attempt Add User with nonGuest token
  it('Token: Attempt Add User with NONGuest token on route /user, responds with 200', async () => {
    // Goal: Add application user
    // Strategy: only guest token can add user
    //           set validation in route route.options.auth
      let payload = {
          aud: 'api-client',
          iss: 'lyttlebit',
          sub: false,
          user: 'user',
          scope: ['user']
      };

      let secret = process.env.LB_JWT_SECRET;
      let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      const res = await server.inject({
          method: 'post',
          url: '/user',
          headers: {
            authorization: token
          },
          payload: {
            username: 'J W',
            displayname: 'J',
            password: 'a1A!aaaa'
          }
      });
      expect(res.statusCode).not.toEqual(200);
  });

  // missing username responds with 401
  // missing displayname responds with 401
  // missing password responds with 401

});
