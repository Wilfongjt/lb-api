import Joi from 'joi';
// [Route:]
// [Description:]
// [Header: token]
// [Header: rollback , default is false]
import { ChelateUser } from '../../../lib/chelates/chelate_user.js';
/*
Post Insert
* requires a guest-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/
module.exports = {
  // [Route:]
  // [Description:]
  // [Header: token]
  // [Header: rollback , default is false]
  method: ['POST'],
  path: '/signup',
  handler: async function (req, h) {
    // [Define a /signup POST route handler]
    // [Signup is a convenience route for /user]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let form ;
    let rollback = false;
    try {
      // [Optionally rollback insert with headers.cleanup=true]
      rollback = req.headers.rollback || false;
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get pk from request.payload]
      form = req.payload;

      // [Insert User into the database]
      await client.query('BEGIN');

      let res = await client.query(
        {
          text: 'select * from api_0_0_1.signup($1::TEXT,$2::JSON)',
          values: [token,
                   JSON.stringify(form)]
        }
      );
      result = res.rows[0].signup;
      if (rollback) {
        // rollback for testing
        await client.query('ROLLBACK');
      } else {
        await client.query('COMMIT');
      }
    } catch (err) {
      await client.query('ROLLBACK');
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/signup err', err);
    } finally {
      // [Release client back to pool]
      client.release();
      // [Return status, msg, and insertion (copy of the inserted record)]
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
            scope: ['api_guest']
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
