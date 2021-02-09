import Joi from 'joi';
import DbClient from '../lib/clients/db_client.js';
import { ChelateUser } from '../lib/chelates/chelate_user.js';
//import { UserAliasChelate } from '../lib/chelate.js';
// app-name   guest
//   |          |

module.exports = {
  method: 'GET',
  path: '/user',

  options: {
        description: 'Restricted access',
        notes: 'Returns ',
        tags: ['api'],
        handler: function (req, h) {
          let client = new DbClient().connect();
          console.log('req', req);
          let selectResponse = {criteria:{pk:'a',sk:'b'}, selection: {message:'hihapi'}};

          return selectResponse;
        }
  }
}
/*
module.exports = {
  method: 'GET',
  path: '/user',

  options: {
        description: 'Restricted access',
        notes: 'Returns ',
        tags: ['api'],
        handler: (req, h) => ({
          message: 'List Hapi.js'
        })
  }
}

*/
/*
module.exports = {
  method: 'GET',
  path: '/user',

  options: {
        description: 'Update User',
        notes: 'Returns ',
        tags: ['api'],
        handler: function (req, h) {
          console.log('GET','user/',req.payload);
          let client = new DbClient().connect();
          let selectResponse = client.select(req.payload);
          return '/user ';
        },
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['app']
          }
        },
        validate: {
          payload: Joi.object({
            sk: Joi.string().min(1).max(4).required(),
            tk: Joi.string()
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
}
*/
