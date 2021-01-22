import Joi from 'joi';
import DbClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js';
import { UserAliasChelate } from '../lib/chelate.js';

module.exports = {
  method: 'POST',
  path: '/user',
  handler: function (req, h) {
    console.log('route /user');
    let client = new DbClient().connect();
    //console.log('table', client.table);
    //let chelate = new UserChelate(req.payload);
    let insertResponse = client.insert(new UserChelate(req.payload));
    client.insert(new UserAliasChelate(insertResponse));
    return '/user route';
  },
  options: {
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['guest']
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
