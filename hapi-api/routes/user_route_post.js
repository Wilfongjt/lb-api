import Joi from 'joi';
import DbClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js';
import { UserAliasChelate } from '../lib/chelate.js';

module.exports = {
  method: 'POST',
  path: '/user',
  handler: function (req, h) {
    let client = new DbClient().connect();
    let insertResponse = client.insert(new UserChelate(req.payload));

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
