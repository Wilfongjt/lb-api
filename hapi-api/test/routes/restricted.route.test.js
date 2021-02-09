import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}

import { init } from '../../lib/server.js';
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../lib/auth/test_token_payload.js';

describe('/restricted route', () => {
    let server = null;

    beforeAll(async () => {

        server = await init();

    });

    afterAll(async () => {
       //console.log('restricted server stop');
        await server.stop();

    });


    it('/restricted : Authorized token, responds with 200', async () => {
        // Goal: call api with application JWT app-token
        // Strategy: configure route validate to check for user and scope

        let payload = new TestTokenPayload().guest_TokenPayload();
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

    it('/restricted : Bad token secret, responds with 401', async () => {
        // Goal: call api with application JWT app-token
        // Strategy: reject when token is made with wrong password/secret

        let payload = new TestTokenPayload().guest_TokenPayload();
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

    it('/restricted : Bad token claim value, responds with 401', async () => {
        // Goal: Enforce authenticated access to an API route
        // Strategy: Reject tokens with wrong claim values
        //           See list of claims in lib/server.js strategy(), verify for required claims

        let payload = new TestTokenPayload().badIss_TokenPayload();
        let secret = process.env.LB_JWT_SECRET;
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

    it('/restricted : Missing token aud claim , responds with 401', async () => {
        // Goal: Enforce authenticated access to an API route
        // Strategy: Reject tokens with missing claims ... hapi requires aud, iss, sub
        //           See list of claims in lib/server.js strategy(), verify for required claims

        let payload = new TestTokenPayload().missingAud_TokenPayload();
        let secret = process.env.LB_JWT_SECRET;
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




    it('/restricted : Missing token user claim, responds with 401', async () => {
        // Goal: call api with application JWT app-token
        // Strategy: create a guest token and
        //           remove guest
        //           pass it to restricted route
        //           expect 401 exception

        let payload = new TestTokenPayload().missingUser_TokenPayload();

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

    it('/restricted : Missing token scope claim, responds with 401', async () => {
      // Goal: call api with application JWT app-token
      // Strategy: create a guest token and
      //           remove scope
      //           pass it to restricted route
      //           expect 401 exception

        let payload = new TestTokenPayload().missingScope_TokenPayload();
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


});
