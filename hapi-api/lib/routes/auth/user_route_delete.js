import Joi from 'joi';
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
    // [Define a /user DELETE route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let pk ;
    let form ;
    try {
      // [Get the API Token from request]
      // [Remove Bearer string from token]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get pk from request]
      form = req.payload; // {pk,sk}
      //console.log('user route delete form ', form);
      pk = form['pk'];
      //console.log('user route delete pk ', pk);
      // [Patch up parameters without #]
      if (! pk.includes('#')) {
        pk = 'username#%s'.replace('%s', pk);
      }
      //console.log('/user route delete pk ', pk);
      // [Delete User from database]

      await client.query('BEGIN');
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::TEXT)',
          values: [token.replace('Bearer ',''),
                   pk]
        }
      );

      result = res.rows[0].user;
      await client.query('COMMIT');

    } catch (err) {
      await client.query('ROLLBACK');
      // [Catch any exceptions]
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/user delete err', err);
    } finally {
      // [Release client back to pool]
      client.release();
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
            scope: ['api_user']
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
