import Joi from 'joi';
//import DbClientRouter from '../clients/db_client_router.js';
//import DbFactory from '../clients/postgres/db_factory.js'; // C
import { Pool } from 'pg';
/*
Post Insert
* requires a user-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/
module.exports = {
  method: 'POST',
  path: '/user',

  options: {
        description: 'Add User aka SignUp',
        notes: 'Returns ',
        tags: ['api'],
        handler: function (req, h) {
          let client = new DbFactory().connect();
          let payload_form = req.payload;
          let signupResponse = client.signup(payload_form);

          return signupResponse;
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
            displayname: Joi.string().min(1).max(20).required(),
            password: Joi.string().min(7).required()
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
}
