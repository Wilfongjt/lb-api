'use strict';
// [Server]
// [Server Launch]
import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  // [Load Environment variables when not in production]
  process.env.DEPLOY_ENV=''
  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
// [Use JWT to control access to API]
import Jwt from '@hapi/jwt';
// [Use HAPI to implement API]
import Hapi from '@hapi/hapi';
// [Use JOI to  validate API inputs]
import Joi from 'joi';
// [Use swagger to facilitate manual interaction with API]
import Inert from '@hapi/inert';
import Vision from '@hapi/vision';
import HapiSwagger from 'hapi-swagger';
import Pack from '../package';

// [Use HapiPgPoolPlugin to start, create, and disconnect postgres client db connections]
import HapiPgPoolPlugin from './plugins/postgres/hapi_pg_pool_plugin.js';
// import { Env Conf } from './environment/env_config.js';

//import { LbEnv } from './environment/lb_env.js';
// Data Client
// [Use helper functions to handle configuration]
import { UserConfig } from './config/user_config.js';
import { DatabaseConfig } from './config/database_config.js';
import { ConnectionConfig } from './config/connection_config.js';

// application handlers
// [Use a chelate metaphor to handle packing all data objects into a single table]
import { ChelateUser } from './chelates/chelate_user.js';

// [Create Example Routes]
import root_route from './routes/examples/root_route.js'; // example
import restricted_route from './routes/examples/restricted_route.js'; // example
import time_route from './routes/examples/time_route.js'; // example

//these need to be rewritten to use the /pg_one
// [Signup and Sigin RoutesCreate User Route]
import signup_route_post from './routes/auth/signup_route_post.js';
import signin_route_post from './routes/auth/signin_route_post.js';
// [Create User Route to demonstrate POST, GET, PUT, and DELETE]
import user_route_post from './routes/auth/user_route_post.js';
import user_route_delete from './routes/auth/user_route_delete.js';
import user_route_get from './routes/auth/user_route_get.js';

import user_route_put from './routes/auth/user_route_put.js';

// [Initialize User Configuration]
const user_config = new UserConfig(process.env.API_DB_USER_CONFIG);
const database_config = new DatabaseConfig(process.env.API_DB_CONFIG);

//const lbEnv = new LbEnv();
//const secret = lbEnv.get('API_JWT_SECRET');
const port = 5555;
const host = process.env.API_HOST ;
//const host = lbEnv.get('API_HOST') ;

const server = Hapi.Server({ host: host, port: port});

const swaggerOptions = {
    info: {
            title: 'Test API Documentation',
            version: Pack.version,
        },
    };

const registrations = [
  Inert,
  Vision,
  // [Register Swagger Plugin]
  {
      plugin: HapiSwagger,
      options: swaggerOptions
  },
  // [Register JWT Plugin]
  Jwt,
  // [Register Postgres Connection Pool Plugin]
  {
    plugin: HapiPgPoolPlugin,
    options: {
      config: {
        user: user_config.user || 'guest_authenticator' || '<username>',
        password: user_config.password || 'guestauthenticatorsecretdatabasepassword' || '<database password>',
        host: database_config.host || 'db' || '<host>',
        database: database_config.database || 'one_db' || '<database>',
        port: database_config.port || 5432 || '<port>',
        guest_token: process.env.API_GUEST_TOKEN  || '<jwt-token>'
      }
    }
  }
];

const api_routes = [
  // [Example Route to root]
  root_route,
  // [Example Route restricted with JWT]
  restricted_route,
  // [Example Route to API]
  time_route,
  // [Register Signin Route]
  signin_route_post,
  // [Register Signup Route]
  signup_route_post,
  // [Register User POST Route]
  user_route_post,
  // [Register User DELETE Route]
  user_route_delete,
  // [Register User GET Route ]
  user_route_get,
  // [Register User PUT Route]
  user_route_put
];

const strategy =  function () {
  // [Authorization Strategy]
  return {
    keys: process.env.API_JWT_SECRET,
    verify: {
        aud: JSON.parse(process.env.API_JWT_CLAIMS).aud || '<audience>',
        iss: JSON.parse(process.env.API_JWT_CLAIMS).iss || '<issuer>',
        sub: JSON.parse(process.env.API_JWT_CLAIMS).sub || '<subject>'
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
  // [Initialize server for testing]

      try {
        await server.register(
          registrations
        );
      // set authentication strategy
      server.auth.strategy('lb_jwt_strategy', 'jwt', strategy() );
      server.auth.default('lb_jwt_strategy');
      server.route(api_routes);

      // use for testing
      await server.initialize();
    } catch(e ){
      //console.log('init DATABASE_URL ',process.env.DATABASE_URL);
      console.log('init register ', e);
    } finally {
      /*
      server.table().forEach((route) => {
          console.log(`${route.method}\t${server.info.uri}${route.path}`);
      });
      */
      //console.log('table',server.table());
      return server;
    }
};


// Declare an authentication strategy using the jwt scheme.
// Use keys: with a shared secret key OR json web key set uri.
// Use verify: To determine how key contents are verified beyond signature.
// If verify is set to false, the keys option is not required and ignored.
// The verify: { aud, iss, sub } options are required if verify is not set to false.
// The verify: { exp, nbf, timeSkewSec, maxAgeSec } paramaters have defaults.
// Use validate: To create a function called after token validation.


exports.start = async () => {
  // [Start server for general use]
    await server.register(
      registrations
    );
    // [Set authorization strategy]
    server.auth.strategy('lb_jwt_strategy', 'jwt', strategy() );
    server.auth.default('lb_jwt_strategy');
    // [Load routes]
    server.route(api_routes);
    // starts server for use
    // [Launch the server]
    await server.start();
    // [Give some feedback about routes]
    let swaggered = false;
    if (process.env.API_PORT) {
      console.log('When using docker-compose');
      // server.table().forEach((route) => console.log(`${route.method}\thttp://${process.env.API_HOST}:${process.env.API_PORT}${route.path}`));
      server.table().forEach((route) => {
        if (!route.path.includes('swagger')) {
          console.log(`${route.method}\thttp://${process.env.API_HOST}:${process.env.API_PORT}${route.path}`);
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
    if (process.env.NODE_ENV === 'development') {

      console.log('Environment')
      for (let ev in process.env) {
        //console.log(ev);
        if (ev.startsWith('LB')) {
          // [No environment variable starting with LB_]
          console.log(ev, process.env[ev]);
        }
        if (ev.startsWith('API')) {
          // [Api environment variables start with API]
          console.log(ev, process.env[ev]);
        }
        if (ev.startsWith('POSTGRES')) {
          // [No environment variables starting with POSTGRES]
          console.log(ev, process.env[ev]);
        }
        if (ev.startsWith('PG')) {
          // [No environment variable starting with PG]
          console.log(ev, process.env[ev]);
        }
      }
    }

    //console.log('user_config.password',user_config.password);
    return server;
};


process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});
// listen on SIGINT signal and gracefully stop the server
/*
process.on('SIGINT', function () {
  console.log('stopping hapi server')

  server.stop({ timeout: 10000 }).then(function (err) {
    console.log('hapi server stopped')
    process.exit((err) ? 1 : 0)
  }

});
*/
server.events.on('stop', () => {
    // [Stops server when ???]
    console.log('Server stopped.');
});
