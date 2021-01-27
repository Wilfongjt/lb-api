import Joi from 'joi';
import DbClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js';
import { UserAliasChelate } from '../lib/chelate.js';
// app-name   guest
//   |          |

module.exports = {
  method: 'PUT',
  path: '/user',
  handler: function (req, h) {
    console.log('/user put 1');
    let client = new DbClient().connect();
    console.log('/user put 2');
    console.log('payload', req.payload);
    console.log('new UserChelate(req.payload))',new UserChelate(req.payload));
    console.log('client', client);
    let insertResponse = client.update(new UserChelate(req.payload));

console.log('/user put out');
    return '/user route';
  },
  options: {
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['app']
          }
        },
        validate: {
          payload: Joi.object({
            username: Joi.string().min(1).max(20).required(),
            displayname: Joi.string().min(1).max(20).required(),
            password: Joi.string().min(7).required()
          })
        }
    }
}
