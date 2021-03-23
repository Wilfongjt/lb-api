'use strict';
import Jwt from '@hapi/jwt';

exports.plugin = {
    pkg: require('../../../package.json'),
    register: async function (server, options) {

        // Create a route for example

        server.route({
            method: 'GET',
            path: '/my_plugin',
            handler: function (request, h) {
              let status = '200';
              let msg = 'OK';
              let result = {};
              let token = '';
              try {
                token = request.headers.authorization.replace('Bearer ','');
                //console.log('plugin  keys', Object.keys(request));

                console.log('plugin payload', request.payload);
                //console.log('plugin headers', request.headers);
                //console.log('plugin authoization', request.headers.authorization);
                //console.log('plugin decode', Jwt.token.decode(token));

                result['payload']=request.headers.payload;
                result['msg']='OK';
                result['status']='200';
              } catch (e) {
                console.log('e', e);
              } finally {
                return result;
              }
            }
        });

        // etc...
        //await someAsyncMethods();
    }
};
