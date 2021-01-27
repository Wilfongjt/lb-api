'use strict';
import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''
  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
// HAPI
import Jwt from '@hapi/jwt';
import Hapi from '@hapi/hapi';
import Joi from 'joi';

import { EnvConf } from './env_config.js';

import { LbEnv } from '../lib/lb_env.js';
// Data Client
import DbClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js';
import { UserAliasChelate } from '../lib/chelate.js';
// ROUTES
import root_route from '../routes/root_route.js';
import restricted_route from '../routes/restricted_route.js';
import user_route_post from '../routes/user_route_post.js';
import user_route_put from '../routes/user_route_put.js';

const lbEnv = new LbEnv();
const secret = lbEnv.get('LB_JWT_SECRET');
const port = 5555; // lbEnv.get('LB_API_PORT');
const host = lbEnv.get('LB_API_HOST') ;

const server = Hapi.Server({ host: host, port: port});

const api_routes = [
  root_route,
  restricted_route,
  user_route_post,
  user_route_put
];

const strategy =  function () {
  return {
    keys: process.env.LB_JWT_SECRET,
    verify: {
        aud: 'api-client',
        iss: 'lyttlebit',
        sub: false
    },
    validate: (artifacts, request, h) => {
      //console.log('validate 1');
        if (! artifacts.decoded.payload.user) {
          return {isValid: false}
        }
        //console.log('validate 2');

        if (! artifacts.decoded.payload.scope) {
          return {isValid: false}
        }
        //console.log('validate 3', artifacts.decoded.payload.user);
        //console.log('validate 4', artifacts.decoded.payload.scope);

        return {
            isValid: true,
            credentials: { user: artifacts.decoded.payload.user, scope: artifacts.decoded.payload.scope }
        };
    }
  }
}

exports.init = async () => {

    await server.register(Jwt);

    server.auth.strategy('lb_jwt_strategy', 'jwt', strategy() );
    // verifyOptions: { algorithms: [ 'HS256' ] }
    server.auth.default('lb_jwt_strategy');

    server.route(api_routes);
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
    server.auth.strategy('lb_jwt_strategy', 'jwt', strategy() );

    // Set the strategy

    server.auth.default('lb_jwt_strategy');

    server.route(api_routes);
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
