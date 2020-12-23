'use strict';
/*
 * app-token is specific to appliction,
             is generated at jwt.io,
             is produced with a secret key value,
             is stashed as env variable,
             is a guest user with name pattern guest@<app>.com and scope of ['guest']

 * user-token is specific to a user,
              is created by the application after authentication,
              is created by the node JWT pluggin,
              is produced with the same secret key value as the app-token,
              is expired in minutes,
              is encoded with user's name and roles.

 * adopter is a user,
           is the same as signup,
           is {displayname: <string>, username: <email>, password: <string>, ...}
           returns success or failure.

 * signin is authentication,
          takes an app-token (in the header), a user name and password,
          creates a signin log entry,
          returns a user-token or failure,

 *
*/


//const Token = require('./lib/token');
const Jwt = require('@hapi/jwt');
const Hapi = require('@hapi/hapi');
const Inert = require('@hapi/inert');
const Vision = require('@hapi/vision');
const HapiSwagger = require('hapi-swagger');

const Pack = require('./package');
//const fs = require('fs');
//const util = require('util');
//const jsonQuery = require('json-query')
const Joi = require('joi');
const { v4: uuidv4 } = require('uuid');
//const crypto = require('crypto');
const DevData = require('./lib/development_data');
//const crypto = require('crypto');
const saltRounds = 10;
const Password = require('./lib/password');
const datetime = require('node-datetime');
if (process.env.NODE_ENV !== 'production') { // environmet vars from .env
  const fs = require('fs');
  if (! fs.existsSync('./.env')) { //for testing
    require('dotenv').config({path: '../.env'});
  } else { // for dev
    require('dotenv').config();
  }
}
const api_token = process.env.LB_API_TOKEN;

const token_secret = process.env.LB_SECRET;
//console.log('claims: ');
const verify_claims = JSON.parse(process.env.LB_JWT_CLAIMS);
/*
{
  isValid:true,
  credentials: {user:<email>, scope:[<string>, <string>,...]},
  results: {result:false} || {result:true, }
}
*/
// Model of an endpoint output
const stub_results = {
  isValid:true,    // JWT status
  credentials: {}, // user identification
  results: {}      // output from endpoint process
};


//////////////////////
const api = (async () => {
  const server = await new Hapi.Server({
     host: '0.0.0.0',
     port: 3001,
  });

  // Set the strategy

  const swaggerOptions = {
     info: {
             title: 'Test API Documentation',
             version: Pack.version,
         },
     };
  await server.register([
     Inert,
     Vision,
     {
         plugin: HapiSwagger,
         options: swaggerOptions
     },
     Jwt
  ]);

  /*
     server.auth.strategy('jwt', 'jwt', {
      keys: token_secret,
      validate: Token.validate,
      verify: verify_claims,
     });
  */

  server.auth.strategy('jwt', 'jwt', {
   keys: token_secret,
   verify: {
        "aud": "lyttlebit-client",
        "iss": "lyttlebit",
        "sub": "app-api"
   },

   validate: async (artifacts, request, h) => {
     /*
      handle the JWT validation
      set up once and configure routes to trigger
     */
     try {
       // Check application token signature, confirms application
       const app_artifacts = Jwt.token.decode(api_token);
       Jwt.token.verify(app_artifacts, token_secret);
       // Check request token signature, confirms token is valid
       const request_artifacts = Jwt.token.decode(request.headers.authorization.replace('Bearer','').replace('bearer ',''));
       Jwt.token.verify(request_artifacts, token_secret);
       // match claims, make sure those that should match do match
       let rc = {isValid: true, credentials: {}};
       for (let itm in request_artifacts.decoded.payload) {
           if (verify_claims[itm] ) { // check value match for
               if (verify_claims[itm] !== request_artifacts.decoded.payload[itm]) {
                 //status.isValid = false;
                 console.log('Mismatched claim: %s (expected: %s) (actual: %s)'
                               .replace('%s', itm)
                               .replace('%s',verify_claims[itm])
                               .replace('%s',request_artifacts.decoded.payload[itm]));
                 throw new Error('Mismatched token');
               }
           } else {  // save xtra stuff for application
               rc.credentials[itm]=request_artifacts.decoded.payload[itm];
           }
       }
       // no need to validate user, we already know token is good
       return {
                   isValid: true,
                   credentials: { user: artifacts.decoded.payload.user }
               };
     } catch(err) {
       console.log('validate: ' + err);
       return { isValid: false };
     }
   }
  });


   // Set the strategy

   server.auth.default('jwt');

   try {
       await server.start();
       console.log('Server running at:', server.info.uri);
   } catch(err) {
       console.log(err);
   }
   //server.route(Routes);
   ///////////
   // State
   ////////

  server.route({
     method: 'GET',
     path: '/env',
     options: {
         auth: {
           mode: "optional",
           strategy: "jwt",
           payload: false
         },
     	   description: 'Get env vals',
         notes: 'Returns current environment variables.',
         tags: ['api'],
         handler: async (request, h) => {

             let results = JSON.parse(JSON.stringify(stub_results));

             results.result={result: true}; // start the response process
             // do your stuff here

             return h.response(results.result)
                      .code(200);
         }, // end handler
         validate: {
              headers: Joi.object({
                   'authorization': Joi.string() /// can i pass a func here
                                       .required()
                                       .description('Application JWT Token')
              }).unknown()

          }

     }
  });



   ///////////
   // Adopters
   ////////
  /*
   server.route({
       method: 'GET',
       path: '/adopter/{pk}/{sk}',
       options: {
       	   description: 'Get list of Adopters',
           notes: 'Returns an array of adopters. GET is for demo only, Use POST instead.',
           tags: ['api'],
           handler: async (request, h) => {
               const pk = request.params.pk;
               const sk = request.params.sk;

               const books = await readFile('./adopt-a-drain.json', 'utf8');
               const all_data = JSON.parse('{"aad": ' + books + '}');
               const results=jsonQuery('aad[pk='+pk+' && sk='+ sk +']', {
                    data: all_data
                });
               return h.response(results.references[0]);
           },
           validate: {
                params: Joi.object({
                    pk : Joi.string()
                            .required()
                            .description('the pk for the todo item'),
                    sk : Joi.string()
                            .required()
                            .description('the sk for the todo item'),
                }), // end handler
                validate: {
                      headers: Joi.object({
                           'authorization': Joi.string()
                                               .required()
                                               .description('Application JWT Token')
                      }).unknown()
                }
            }
       }
   });
   */


  server.route({
     method: ['POST','PUT'],
     path: '/adopter',
     options: {
       auth: {
         mode: "optional",
         strategy: "jwt",
         payload: false
       },
       description: 'Add adopter to list',
       notes: 'Returns adopter credentials without password',
       tags: ['api'],
       handler: async (request, h) => {
           // authorization: the hapi/jwt framework will look for JWT and validate
           // user-tokens are different than app-tokens
           //   - they have name and scope in addition to iss,
           // insert: break down the payload and format for storage
           //const token_secret = process.env.LB_SECRET;
           // adopters are unique by pk and sk
           const payload = request.payload;  // request payload
           let saltRounds = 12;              // used for hashing password
           const uuid_ = uuidv4();           // use to generate uuid for item
           let results = JSON.parse(JSON.stringify(stub_results)); // make copy of expected data

           try {
             //results.credentials=temp.credentials
             // do your stuff here

             // add augmentation: ie {type: "adopter", uuid: "<uuidv4()>"}, hash pw
             // test for existing object
             // insert if not exists
             // update if exists
             //const _hash = Password.hash(payload.password, saltRounds);
             const _datetime = new Date();
             // reorganize payload
             payload.id = payload.username;
             payload.key = uuid_;
             payload.name = payload.username;
             payload.type = "adopter";
             payload.password = Password.hash(payload.password, saltRounds);
             // const book = {
             const wrapper = {
                 "pk": payload.username,
                 "sk": "profile#%s".replace('%s',payload.username),
                 "data": "adopter",
                 "form": payload,
                 "active": true,
                 "created": _datetime,
                 "updated": _datetime
             };

             /////////////////////////////////////
             // Store object
             // this is an adhoc solution
             // swap in your data solution here
             DevData.getData('./lib/development_data.json')
                     .then(function(data){
                       data.push(wrapper);
                       DevData.setData('./lib/development_data.json', data);
                     });
             // end data storage
             /////////////////////////////////////

             ////////////////////////////////
             // begin preparing the response
             // remove the password
             delete payload.password;
             results.result=payload;

             return h.response(results.result)
                      .code(200);
          }catch(err){
            console.log('adopter: ' + err);

          }

       }, // endhandler
       validate: {
            payload: Joi.object({
                username: Joi.string(),
                password: Joi.string(),
                displayname: Joi.string()
            }),
            headers: Joi.object({
                 'authorization': Joi.string()
                                     .required()
                                     .description('Application JWT Token')
            }).unknown()
        }
     }
  });   // end endpoint



/*
          server.route({
               method: 'POST',
               path: '/adopter',
               options: {
                 description: 'Add adopter to list',
                 notes: 'Returns an array of books',
                 tags: ['api'],
                   handler: async (request, h) => {
                       //const book = JSON.parse(request.payload);
                       const book = request.payload;
                       let books = await readFile('./aad.json', 'utf8');
                       books = JSON.parse(books);
                       // setting id
                       book.id = books.length + 1;
                       books.push(book);
                       await writeFile('./aad.json', JSON.stringify(books, null, 2), 'utf8');
                       return h.response(books).code(200);
                   }
               }
          });

          server.route({
              method: 'PUT',
              path: '/aad/{id}',
              options: {
                description: 'Update book at key',
                notes: 'Returns an array of books',
                tags: ['api'],
                  handler: async (request, h) => {
                      // const updBook = JSON.parse(request.payload);
                      const updBook = request.payload;
                      const id = request.params.id;
                      let books = await readFile('./aad.json', 'utf8');
                      books = JSON.parse(books);
                      // finding book by id and rewriting
                      books.forEach((book) => {
                          if (book.id == id) {
                              book.title = updBook.title;
                              book.author = updBook.author;
                          }
                      });
                      await writeFile('./aad.json', JSON.stringify(books, null, 2), 'utf8');
                      return h.response(books).code(200);
                  }
              }
          });
*/
          /*
          server.route({
             method: 'DELETE',
             path: '/aad/{id}',
             options: {
               description: 'Delete a book at key from list',
               notes: 'Returns an array of books',
               tags: ['api'],
                 handler: async (request, h) => {
                     // const updBook = JSON.parse(request.payload);
                     const updBook = request.payload;

                     const id = request.params.id;
                     let books = await readFile('./aad.json', 'utf8');
                     books = JSON.parse(books);
                     // rewriting the books array
                     books = books.filter(book => book.id != id);
                     await writeFile('./aad.json', JSON.stringify(books, null, 2), 'utf8');
                     return h.response(books).code(200);
                 }
             }
         });
         */
})();


       /*
       const book = {
           "pk": payload.username,
           "sk": "profile#%s".replace('%s',payload.username),
           "data": "adopter",
           "form": {
               "id": payload.username,
               "key": uuid_,
               "name": payload.username,
               "type": "adopter",
               "password": _hash,
               "displayname": payload.displayname
           },
           "active": true,
           "created": _datetime,
           "updated": _datetime
       };
       */
