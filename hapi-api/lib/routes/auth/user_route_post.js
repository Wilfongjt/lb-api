import Joi from 'joi';
//import DbClientRouter from '../clients/db_client_router.js';
//import DbFactory from '../clients/postgres/db_factory.js'; // C
//import { Pool } from 'pg';
import { ChelateUser } from '../../../lib/chelates/chelate_user.js';
/*
Post Insert
* requires a user-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/
module.exports = {
  method: 'POST',
  path: '/user',
  handler: async function (req, h) {
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let chelate ;
    try {
      token = req.headers.authorization; // guest token
      // expect a user data form with {username, displayname, password}
      console.log('/user req.payload',req.payload);
      chelate = new ChelateUser(req.payload);
//console.log('/user post chelate ', chelate);
//need insert chelates and query chelates
      // verify token?? not sure how to do that in JOI, is done in DB
      // verify minimum user using JOI below
      client = req.pg;
      let res = await client.query(
        {
          text: 'select * from one_version_0_0_1.user_ins($1,$2)',
          values: [token,JSON.stringify(chelate)]
        }
      );
      result = res.rows[0].user;
    } catch (err) {
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.log('/user err', err)
    } finally {
      client.release();
      return result;
    }
  },
  options: {
        description: 'Add User aka SignUp',
        notes: 'Returns {} ',
        tags: ['api'],
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
