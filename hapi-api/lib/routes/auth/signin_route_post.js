import Joi from 'joi';

module.exports = {
  // [Route:]
  // [Description:]
  // [Header: token]
  // [Header: rollback , default is false]
  method: 'POST',
  path: '/signin',
  handler: async function (req, h) {
    // [Define a /signin POST route handler]
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    let form ;

    try {
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      form = req.payload;
      // [Get credentials from request]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.signin($1::TEXT,$2::JSON)',
          values: [token.replace('Bearer ',''),
                   form]
        }
      );

      result = res.rows[0].signin;

      /*
      if (result.status !== '200') {
        result['payload'] = req.payload;
        result['payload'].password = '********';
      }*/
    } catch (err) {
      // [Catch any exceptions]
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.error('/signin err',err);
    } finally {
      client.release();

      // [Return {status, msg, token}]
      return result;
    }
  },
  options: {
        description: 'User Signin with Guest Token',
        notes: 'signin(token, credentials) Returns a {credentials: {username: email}, authentication: {token: JWT} | false }',
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
            password: Joi.string().min(8).required()
          }),
          headers: Joi.object({
               'authorization': Joi.string().required()
          }).unknown()
        }
    }
};
