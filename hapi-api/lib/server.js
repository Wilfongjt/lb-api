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
// swagger
import Inert from '@hapi/inert';
import Vision from '@hapi/vision';
import HapiSwagger from 'hapi-swagger';
import Pack from '../package';

import { EnvConf } from './environment/env_config.js';

import { LbEnv } from './environment/lb_env.js';
// Data Client
import DbClient from './clients/db_client.js';
import { ChelateUser } from './chelates/chelate_user.js';

// ROUTES
import root_route from '../routes/examples/root_route.js'; // example
import restricted_route from '../routes/examples/restricted_route.js'; // example

import user_route_post from '../routes/user_route_post.js';
import user_route_put from '../routes/user_route_put.js';
import user_route_get from '../routes/user_route_get.js';
import signin_route_post from '../routes/signin_route_post.js';

const lbEnv = new LbEnv();
const secret = lbEnv.get('LB_JWT_SECRET');
const port = 5555; // lbEnv.get('LB_API_PORT');
const host = lbEnv.get('LB_API_HOST') ;

const server = Hapi.Server({ host: host, port: port});
const swaggerOptions = {
    info: {
            title: 'Test API Documentation',
            version: Pack.version,
        },
    };

const api_routes = [
  root_route, // example
  restricted_route, // example
  user_route_post,
  user_route_put,
  user_route_get,
  signin_route_post
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
        if (! artifacts.decoded.payload.user) {
          return {isValid: false}
        }

        if (! artifacts.decoded.payload.scope) {
          return {isValid: false}
        }

        return {
            isValid: true,
            credentials: { user: artifacts.decoded.payload.user, scope: artifacts.decoded.payload.scope }
        };
    }
  }
}

exports.init = async () => {

    //await server.register(Jwt);
    await server.register([
            Inert,
            Vision,
            {
                plugin: HapiSwagger,
                options: swaggerOptions
            },
            Jwt
        ]);
    // set authentication strategy
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

    //await server.register(Jwt);
    await server.register([
            Inert,
            Vision,
            {
                plugin: HapiSwagger,
                options: swaggerOptions
            },
            Jwt
        ]);
    // set authentication strategy
    server.auth.strategy('lb_jwt_strategy', 'jwt', strategy() );
    // Set the strategy
    server.auth.default('lb_jwt_strategy');

    server.route(api_routes);
    // starts server for use

    await server.start();
    let swaggered = false;
    if (process.env.LB_API_PORT) {
      console.log('When using docker-compose');
      // server.table().forEach((route) => console.log(`${route.method}\thttp://${process.env.LB_API_HOST}:${process.env.LB_API_PORT}${route.path}`));
      server.table().forEach((route) => {
        if (!route.path.includes('swagger')) {
          console.log(`${route.method}\thttp://${process.env.LB_API_HOST}:${process.env.LB_API_PORT}${route.path}`);
        } else {
          swaggered = true;
        }
      });
    }
    console.log("Otherwise");
    server.table().forEach((route) => {
      if (!route.path.includes('swagger')) {
        console.log(`${route.method}\t${server.info.uri}${route.path}`);
      } else {
        swaggered = true;
      }
    });

    if (swaggered) {
      console.log(`Swagger enabled at /documentation`);
    }

    console.log('guest token', );

    return server;
};


process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});
