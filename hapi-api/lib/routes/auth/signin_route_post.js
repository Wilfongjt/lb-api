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
      // [Optionally insert a test user]
      let test = req.headers.test || false;
      // [Get the API Token from request]
      token = req.headers.authorization; // guest token
      // [Get a database client from request]
      client = req.pg;
      // [Get form from request.params]
      form = req.payload;

      if (test) {
        // [Inititate a transation when test is invoked]
        await client.query('BEGIN');
        // [Insert a transation when test is invoked]
        let res = await client.query(
          {
            text: 'select * from api_0_0_1.signup($1::TEXT,$2::JSON)',
            values: [token,
                     JSON.stringify(test)]
          }
        );
      }

      // [Get credentials from request]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.signin($1::TEXT,$2::JSON)',
          values: [token.replace('Bearer ',''),
                   form]
        }
      );

      result = res.rows[0].signin;
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
      console.error('/signin err',err);
    } finally {
      // [Release client back to pool]
      client.release();
      // [Return {status, msg, token}]
      return result;
    }
  },
  options: {
        cors: {
            origin:["*"],
            headers:['Accept', 'Authorization', 'Content-Type', 'If-None-Match', 'Content-Profile']
        },
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
