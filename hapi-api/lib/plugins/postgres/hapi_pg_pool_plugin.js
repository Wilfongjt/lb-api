'use strict';
import { Pool, Client } from 'pg';
import Jwt from '@hapi/jwt';

//import DbFactory from '../../../lib/clients/postgres/db_factory.js';
//import DbClient from '../../../lib/clients/postgres/db_client.js';
//import { Hapi PgPoolHelper, Client } from '../../../lib/plugins/postgres/helpers/hapi_pg_pool_helper.js';
/*
const config = {
  user: process.env.PGUSER || 'postgresx',
  host: process.env.PGHOST || 'dbx',
  database: process.env.PGDATABASE || 'one_dbx',
  password: process.env.PGPASSWORD || 'mysecretdatabasepasswordx',
  port: process.env.PGPORT || 5433,
  guest_token: process.env.API_GUEST_TOKEN,
  Client: Client
};
*/
//const pool = new DbFactory(config); // warm up the pool
const pools = {};
let run_once = false;
const PG_CON = []; // this "global" is local to the plugin.

// create a pool
//const pool = new Pool(config);

/*
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_SSL || false
});
*/
//
/*
async function assign_connection (request, h) { // DRY
  request.pg = await module.exports.getCon();
  return h.continue;
}*/
//
/*
module.exports.getCon = async function () {
  if (!PG_CON[0]) {
    await createPoolConnection();
    return PG_CON[0];
  }
  return PG_CON[0];
};
*/
exports.plugin = {
    pkg: require('../../../package.json'),
    version: '1.0.0',

    register: async function (server) {
       // connection using created pool
       server.ext({
         type: 'onPreAuth',
         method: async function (request, h) {

           try {
             if (!request.route.settings.auth) {

             }
               if (!pools.pool) {
                 pools['pool'] = new Pool(h.realm.pluginOptions.config);
               }
               //console.log('HapiPgPoolPlugin request.route',request.route);
               //console.log('HapiPgPoolPlugin request.route.settings.auth',request.route.settings.auth);
               if (request.route.settings.auth) {
                 let client  = await pools.pool.connect();
                 PG_CON.push({ client });
                 request.pg = client;
                 //console.log('HapiPgPoolPlugin connect');
               } else {
                 console.log('HapiPgPoolPlugin request.route.path',request.route.path);

                 //console.log('HapiPgPoolPlugin auth ', request.route.settings.auth);
                 console.log('HapiPgPoolPlugin auth',request.route.settings.auth);
                 console.log('HapiPgPoolPlugin request.route.method',request.route.method);

                 console.log('HapiPgPoolPlugin')
                 //console.log('HapiPgPoolPlugin ',request.route.path ,request.route.method , request.route.settings.auth);
               }
               if(!run_once) {
                 run_once = true;
                 server.events.on('stop', async function () { // only one server.on('stop') listener

                   //console.log('Connection pool closing');
                   //await pools.pool.end();
                   PG_CON.forEach(async function (con) { // close all the connections
                                 await con.client.end();
                               });
                 });
               }

           } catch(err) {
             console.log('HapiPgPoolPlugin err', err);
           } finally {
             //console.log('HapiPgPoolPlugin out');
             return h.continue;
           }
         }
       });
     }

};
