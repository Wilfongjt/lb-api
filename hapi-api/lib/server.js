'use strict';
import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''
  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import Jwt from '@hapi/jwt';
import { EnvConf } from './env_config.js';
import Hapi from '@hapi/hapi';
import { LbEnv } from '../lib/lb_env.js';

const lbEnv = new LbEnv();
const secret = lbEnv.get('LB_JWT_SECRET');
const port = 5555; // lbEnv.get('LB_API_PORT');
const host = lbEnv.get('LB_API_HOST');

const server = Hapi.Server({ host: host, port: port});
// ROUTES
// auth: false ... turn off authentication
server.route({
  method: 'GET',
  path: '/',
  handler: (req, h) => ({ message: 'Hello Hapi.js' }),
  options: {
       auth: false
  }
});
server.route({
  method: 'GET',
  path: '/restricted',
  handler: (req, h) => ({ message: 'List Hapi.js' })
});

const strategy =  function () {
  return {
    keys: process.env.LB_JWT_SECRET,
    verify: {
        aud: 'api-client',
        iss: 'lyttlebit',
        sub: false
    },
    validate: (artifacts, request, h) => {
        // console.log('strategy validate fires after authorization/authentication');
        return {
            isValid: true,
            credentials: { user: artifacts.decoded.payload.user }
        };
    }
  }
}

exports.init = async () => {

    await server.register(Jwt);

    server.auth.strategy('my_jwt_stategy', 'jwt', strategy() );
    // verifyOptions: { algorithms: [ 'HS256' ] }
    server.auth.default('my_jwt_stategy');

    // use for testing

    await server.initialize();
    return server;
};


// Declare an authentication strategy using the jwt scheme.
// Use keys: with a shared secret key OR json web key set uri.
// Use verify: To determine how key contents are verified beyond signature.
// If verify is set to false, the keys option is not required and ignored.
// The verify: { aud, iss, sub } options are required if verify is not set to false.
// The verify: { exp, nbf, timeSkewSec, maxAgeSec } paramaters have defaults.
// Use validate: To create a function called after token validation.


exports.start = async () => {

    await server.register(Jwt);
    // set authentication strategy
    server.auth.strategy('my_jwt_stategy', 'jwt', strategy() );

    // Set the strategy

    server.auth.default('my_jwt_stategy');

    // starts server for use

    await server.start();

    console.log(`Server running at: ${server.info.uri}`);
    server.table().forEach((route) => console.log(`${route.method}\t${server.info.uri}${route.path}`));

    return server;
};


process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});
