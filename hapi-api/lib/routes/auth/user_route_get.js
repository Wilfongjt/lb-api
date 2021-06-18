import Joi from 'joi';
import Jwt from '@hapi/jwt';
import TestTokenPayload from '../../auth/test_token_payload.js';

//import { ChelateUser } from '../chelates/chelate_user.js';
//import { UserAliasChelate } from '../chelate.js';
// app-name   guest
//   |          |

module.exports = {
  method: 'GET',
  path: '/user/{username}',
  handler: async function (req, h) {
    // [Define a /user GET route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let form ;
    let username ;
    let options = {};
    try {
      // [Optionally insert a test user]
      let test = req.headers.test || false;
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get username from request.params]
      username = req.params.username;

      if (test) {
        // [Inject a test record when test is specified]
        let guestTokenPayload = new TestTokenPayload().guest_TokenPayload();
        let secret = process.env.API_JWT_SECRET;
        let guestToken = 'Bearer ' + Jwt.token.generate(guestTokenPayload, secret);
        // [Inititate a transation when test is invoked]
        await client.query('BEGIN');
        // [Insert a transation when test is invoked]
        let res = await client.query(
          {
            text: 'select * from api_0_0_1.signup($1::TEXT,$2::JSON)',
            values: [guestToken,
                     JSON.stringify(test)]
          }
        );
      }

      // [Patch up username parameter without #]
      if (! username.includes('#')) {
        username = 'username#%s'.replace('%s', username);
      }
      // [GET payload in header]
      form = {pk:username,
              sk:'const#USER'};

      // [Get options from request payload]
      options = {};

      // [Get User from database]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::JSON,$3::JSON)',
          values: [token,
                   form,
                   options]
        }
      );

      result = res.rows[0].user;
      if (test) {
        // [Rollback transaction when when test is invoked]
        await client.query('ROLLBACK');
      }

    } catch (err) {
      // [Catch any exceptions]
      if (test) {
        // [Rollback transacton when excepton occurs and test is invoked]
        await client.query('ROLLBACK');
      }
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/user GET err', err);
    } finally {
      // [Release client back to pool]
      client.release();
      // [Return status, msg, and deletion (copy of the deleted record)]
      return result;
    }
  },
  options: {
        description: 'Restricted access',
        notes: 'Returns ',
        tags: ['api'],
        auth: {
          mode: 'required',
          strategy: 'lb_jwt_strategy',
          access: {
            scope: ['api_user','api_admin']
          }
        },
        validate: {
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown(),
          params: Joi.object({
              username: Joi.string().required()
          })
        }
  },
}

/*
payload: Joi.object({
    pk:Joi.string().min(1).max(256).required(),
    sk:Joi.string().min(1).max(256).required(),
    tk:Joi.string().min(1).max(256).optional()
})
payload: Joi.object({
  criteria: Joi.object({
    pk:Joi.string().min(1).max(256).required(),
    sk:Joi.string().min(1).max(256).required(),
    tk:Joi.string().min(1).max(256).optional()
  }),
  options: Joi.any().optional()
}),
*/
