'use strict';
import Hapi from '@hapi/hapi';
//import Hapi from 'hapi/hapi';
//import Hapi from 'hapi';
//import Hapi from '@hapi/hapi';
const server = Hapi.Server({ host: '0.0.0.0', port: 5555 });
server.route({
  method: 'GET',
  path: '/',
  handler: (req, h) => ({ message: 'Hello Hapi.js' })
});

exports.init = async () => {
    // use for testing 
    await server.initialize();
    return server;
};

/*
const init = async () => {
  server.route({
    method: 'GET',
    path: '/',
    handler: (req, h) => ({ message: 'Hello Hapi.js' })
  });

  await server.start();
  console.log('Server is running on http://localhost:5555');
}

init();
*/


exports.start = async () => {
  //console.log('start 1');
  //const server = Hapi.Server({ host: '0.0.0.0', port: 5555 });

    /*
    await server.register(Jwt);


    // Declare an authentication strategy using the jwt scheme.
    // Use keys: with a shared secret key OR json web key set uri.
    // Use verify: To determine how key contents are verified beyond signature.
    // If verify is set to false, the keys option is not required and ignored.
    // The verify: { aud, iss, sub } options are required if verify is not set to false.
    // The verify: { exp, nbf, timeSkewSec, maxAgeSec } paramaters have defaults.
    // Use validate: To create a function called after token validation.


    server.auth.strategy('my_jwt_stategy', 'jwt', {
        keys: secret,
        verify: {
            aud: 'urn:audience:test',
            iss: 'urn:issuer:test',
            sub: false
        },
        validate: (artifacts, request, h) => {
            console.log('validate');
            return {
                isValid: false,
                credentials: { user: artifacts.decoded.payload.user }
            };
        }
    });


    // Set the strategy

    server.auth.default('my_jwt_stategy');
    */

    //console.log('start 2 server ', server.settings);
    // starts server for use
    await server.start();
    //console.log('start 3 server ', server.settings)
    console.log(`Server running at: ${server.info.uri}`);
    return server;
};


process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});
