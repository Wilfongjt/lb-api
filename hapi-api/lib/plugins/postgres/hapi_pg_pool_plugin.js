'use strict';
import { Pool, Client } from 'pg';
import Jwt from '@hapi/jwt';
//const connectionString = 'postgresql://dbuser:secretpassword@db:3211/mydb';
//PG USER
//PG PASSWORD
//PG PORT
//PG DATABASE
//import { Hapi PgPoolHelper, Client } from '../../../lib/plugins/postgres/helpers/hapi_pg_pool_helper.js';
/*
const config = {
  user: process.env.PG USER || 'postgresx',
  host: process.env.PG HOST || 'dbx',
  database: process.env.PG DATABASE || 'one_dbx',
  password: process.env.PG PASSWORD || 'mysecretdatabasepasswordx',
  port: process.env.PG PORT || 5433,
  guest_token: process.env.API _GUEST_TOKEN,
  Client: Client
};
*/
//const pool = new DbFactory(config); // warm up the pool
const pools = {};
let run_once = false;
const PG_CON = []; // this "global" is local to the plugin.

exports.plugin = {
    pkg: require('../../../package.json'),
    version: '1.0.0',

    register: async function (server) {
      // [Hapi Postgres Client Pool Plugin]
      // [Description: Create several database connections to speed things up.]
       // connection using created pool
       server.ext({
         type: 'onPreAuth',
         method: async function (request, h) {
           try {
             //console.log('h',h);
               if (!('pool' in pools)) {
                 // [Initialize connection pool]
                 pools['pool'] = new Pool(h.realm.pluginOptions.config);
               }
               //console.log('h.realm.pluginOptions',h.realm.pluginOptions);

               if (request.route.settings.auth) {
                 // [Retrieve a client connection from pool When authenticated]
                 let client  = await pools.pool.connect();
                 PG_CON.push({ client });
                 request.pg = client;
               }
               if(!run_once) {
                 run_once = true;
                 server.events.on('stop', async function () { // only one server.on('stop') listener
                   // [Register handler to close connections when app is shutdown/stopped]
                   PG_CON.forEach(async function (con) { // close all the connections
                                 await con.client.end();
                               });
                 });
               }
           } catch(err) {
             console.log('HapiPgPoolPlugin err1 ', err);
             console.log('hapiPgPoolPlugin err2 ', pools)
           } finally {
             return h.continue;
           }
         }
       });
     }

};
