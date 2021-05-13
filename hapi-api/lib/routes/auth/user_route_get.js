import Joi from 'joi';
//import { ChelateUser } from '../chelates/chelate_user.js';
//import { UserAliasChelate } from '../chelate.js';
// app-name   guest
//   |          |

module.exports = {
  method: 'GET',
  path: '/user/{username}',
  handler: async function (req, h) {
    //console.log('/user GET 1');
    // [Define a /user GET route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let form ;
    let username ;
    //let criteria ;
    let options = {};
    try {
      //console.log('/user route GET 2');
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      username = req.params.username;
      // [Patch up username parameter without #]

      if (! username.includes('#')) {
        username = 'username#%s'.replace('%s', username);
      }
      // [GET payload in header]
      form = {pk:username,
              sk:'const#USER'};

      //form = req.headers.payload;
      //form = req.payload;
      // [Get criteria from request payload]
      //criteria = ;
      // [Get options from request payload]
      options = {};
      //console.log('/user route GET 3 token ', token);
      //console.log('/user route GET 3 form ', form);
      //console.log('/user route GET 3');

      // [Get User from database]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.user($1::TEXT,$2::JSON,$3::JSON)',
          values: [token.replace('Bearer ',''),
                   form,
                   options]
        }
      );
      //console.log('/user route GET 4');

      result = res.rows[0].user;
      //console.log('/user route GET 5');

    } catch (err) {
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/user GET err', err);
    } finally {
      // [Release client back to pool]
      client.release();
      //console.log('/user route GET out');
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
            scope: ['api_user']
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
