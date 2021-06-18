import Joi from 'joi';
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../auth/test_token_payload.js';

//import { Pool } from 'pg';
import { ChelateUser } from '../../../lib/chelates/chelate_user.js';
/*
Post Insert
* requires a user-token
* payload must contain {pk:"", sk:"", ...} or  {sk:"", tk:"", ...}
* payload must contain a {...,"form": {...}} key
*/
module.exports = {
  method: 'DELETE',
  path: '/user',
  handler: async function (req, h) {
    //console.log('route delete 1')

    // [Define a /user DELETE route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let pk ;
    let form ;
    try {
      // [Get the API Token from request]
      let test = req.headers.test || false;
      // [Get the API Token from request header]
      token = req.headers.authorization; // user token
      // [Get a database client from request]
      client = req.pg;
      // [Get pk from request]
      form = req.payload; // {pk,sk}
      pk = form['pk'];
      // [Patch up parameters without #]
      if (! pk.includes('#')) {
        pk = 'username#%s'.replace('%s', pk);
      }
      // [Delete is wrapped in a transaction]
      await client.query('BEGIN');
      if (test) {
        // [Add test record when test is found in header]
        let guestTokenPayload = new TestTokenPayload().guest_TokenPayload();
        let secret = process.env.API_JWT_SECRET;
        let guestToken = 'Bearer ' + Jwt.token.generate(guestTokenPayload, secret);
        // [Insert a transation when test is invoked]
        let resSU = await client.query(
          {
            text: 'select * from api_0_0_1.signup($1::TEXT,$2::JSON,$3::TEXT)',
            values: [guestToken,
                     JSON.stringify(test.form),
                     test.user_key
                    ]
          }
        );
      }
      // [Delete User from database]
      //console.log('route delete 8')

      //await client.query('BEGIN');
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::TEXT)',
          values: [token,
                   pk]
        }
      );
      //console.log('route delete 9')

      result = res.rows[0].user;
      if (test) {
        // [Rollback transaction when when test is invoked]
        await client.query('ROLLBACK');
      } else {
        // [Commit transaction when not testing]
        await client.query('COMMIT');
      }
      //console.log('route delete 10')

    } catch (err) {
      //console.log('route delete 11')

      // [Catch any exceptions and Rollback changes]
      await client.query('ROLLBACK');
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/user delete err', err);
    } finally {
      //console.log('route delete 12')

      // [Release client back to pool]
      client.release();
      //console.log('route delete out')

      // [Return status, msg, and deletion (copy of the deleted record)]
      return result;
    }
  },
  options: {
        description: 'Delete User',
        notes: 'Returns {} ',
        tags: ['api'],
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['api_user','api_admin']
          }
        },
        validate: {
          payload: Joi.object({
            pk: Joi.string().min(1).max(256).required()
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
}
//            sk: Joi.string().min(1).max(256).required(),
