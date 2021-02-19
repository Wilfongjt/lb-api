import Joi from 'joi';
import DbClientRouter from '../lib/clients/db_client_router.js';

module.exports = {
  method: 'POST',
  path: '/signin',
  options: {
        description: 'User Signin with Guest Token',
        notes: 'Returns a {credentials: {username: email}, authentication: {token: JWT} | false }',
        tags: ['api'],
        handler: function (req, h) {
          let client = new DbClientRouter().connect();
          let signinResponse = client.signin(req.payload);
          return signinResponse;
        },
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
            password: Joi.string().min(8).required()
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
};
