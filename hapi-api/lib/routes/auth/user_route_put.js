import Joi from 'joi';
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../auth/test_token_payload.js';
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

    try {
      // [Get the API Token from request]
      let test = req.headers.test || false;
      // [Get the API Token from request header]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get pk from request]
      pk = req.payload.pk;
      // [Assemble the update form]
      form = req.payload.form;
      // [PUT is wrapped in a transaction]
      await client.query('BEGIN');
      if (test) {
        // [Inject a test record when test is specified]
        let guestTokenPayload = new TestTokenPayload().guest_TokenPayload();
        let secret = process.env.API_JWT_SECRET;
        let guestToken = 'Bearer ' + Jwt.token.generate(guestTokenPayload, secret);
        // [Insert a transation when test is invoked]
        let res = await client.query(
          {
            text: 'select * from api_0_0_1.signup($1::TEXT,$2::JSON,$3::TEXT)',
            values: [guestToken,
                     JSON.stringify(test.form),
                     test.user_key
                   ]
          }
        );
      }
      ////////



      ////////

      // [Update user in database]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::TEXT,$3::JSON)',
          values: [token,
                   pk,
                   form]
        }
      );
      result = res.rows[0].user;
      if (test) {
        // [Rollback transaction when when test is invoked]
        await client.query('ROLLBACK');
      } else {
        // [Commit transaction when not testing]
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
      // [Return status, msg, and deletion (copy of the updated record)]
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
