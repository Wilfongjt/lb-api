import Joi from 'joi';
import DbClient from '../lib/clients/db_client.js';
import { ChelateUser } from '../lib/chelates/chelate_user.js';
/*
Put Update
* requires a user-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/
module.exports = {
  method: 'PUT',
  path: '/user',

  options: {
        description: 'Update User',
        notes: 'Returns ',
        tags: ['api'],
        handler: function (req, h) {
          let client = new DbClient().connect();
          let payload = req.payload;
          let updateResponse = client.update(payload);
          return updateResponse;
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
            sk: Joi.string().min(1).max(50).required(),
            tk: Joi.string().required(),
            form: {
              username: Joi.string().min(1).max(250).required(),
              displayname: Joi.string().min(1).max(20).required(),
              password: Joi.string().min(7).required()
            }
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
}
