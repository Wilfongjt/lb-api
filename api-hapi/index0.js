'use strict';

       const Hapi = require('@hapi/hapi');
       //const Hapi = require('hapi');
       const fs = require('fs');
       const util = require('util');

       // Convert fs.readFile, fs.writeFile into Promise version of same
       const readFile = util.promisify(fs.readFile);
       const writeFile = util.promisify(fs.writeFile);

       const init = async () => {
           const server = Hapi.server({
               port: process.env.LB_API_PORT || 3001,
               host: process.env.LB_API_HOST || '0.0.0.0'
           });
           server.route({
               method: 'GET',
               path: '/',
               handler: (request, h) => {
                   let rc = [
                     {name: "signup",
                      method: "POST",
                      inputs:[{"type":"signup", "name":"<user-name>", "password":"<password>"}],
                      output:{"app-token":"<jwt-token>"}
                     }
                     ,
                     {name: "signin",
                      method: "POST",
                      header: {"token":"<app-token>"},
                      inputs:[{"type":"signin", "name":"<user-name>", "password":"<password>"}],
                      output:{"token":"<user-token>"}
                     },
                     {name: "instructions",
                      method: "GET",
                      inputs:[{"type":"instructions"}],
                      output:{}
                     },
                     {name: "_upsert",
                      method: "POST",
                      header: {"token":"<user-token>"},
                      inputs:[{"type":"upsert", "token": "<jwt-token>", "form":{}}],
                      output:{}
                     },
                     {name: "_delete",
                      method: "POST",
                      header: {"token":"<app-token>"},
                      inputs:[{"type":"delete", "token": "<jwt-token>", id:"<id-value>"}],
                      output:{}
                     }
                   ];
                   /*

                   */

                   return rc;
               }
           });
           await server.start();
           // console.log(process.env);
           console.log('Server running on %s ', server.info.uri );
       };

       process.on('unhandledRejection', (err) => {
           console.log(err);
           process.exit(1);
       });
       init();
