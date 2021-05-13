import Joi from 'joi';

import { ChelateUser } from '../../../lib/chelates/chelate_user.js';
/*
Put Update
* requires a user-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/

// [TODO: verify code works]
module.exports = {
  // [Route: /user PUT]
  // [Description:]
  // [Header: token]
  method: 'PUT',
  path: '/user',
  handler: async function (req, h) {
    // [Define a /user PUT route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let form ;
    let pk ;
    let rollback = false;
    try {
      // [Optionally rollback insert with headers.rollback=true]
      rollback = req.headers.rollback || false;
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get pk from request]
      pk = req.payload.pk;
      // [Assemble the update form]
      form = req.payload.form;

      // [Delete User from database]
      // token TEXT,pk TEXT,form JSON
      await client.query('BEGIN');
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::TEXT,$3::JSON)',
          values: [token.replace('Bearer ',''),
                   pk,
                   form]
        }
      );
      result = res.rows[0].user;
      if (rollback) {
        // rollback for testing
        await client.query('ROLLBACK');
      } else {
        await client.query('COMMIT');
      }
    } catch (err) {
      // [Catch any exceptions and Rollback changes]
      await client.query('ROLLBACK');
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/user put err', err);
    } finally {
      // [Release client back to pool]
      client.release();
      // [Return status, msg, and deletion (copy of the deleted record)]
      return result;
    }
  },
  options: {
        description: 'Update User',
        notes: 'Returns ',
        tags: ['api'],
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['api_user']
          }
        },
        validate: {
          payload: Joi.object({
            pk: Joi.string().min(1).max(50).required(),
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
