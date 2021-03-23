import Joi from 'joi';
//import DbClientRouter from '../clients/db_client_router.js';
//import DbFactory from '../clients/postgres/db_factory.js'; //A

module.exports = {
  method: 'POST',
  path: '/signin',
  handler: async function (req, h) {
    let result = {status:"200", msg:"OK"};
    let client ;
    let token ; // guest token
    // verify token ??
    try {
      token = req.headers.authorization; // guest token
      client = req.pg;
      // payload is criteria
      let res = await client.query(
        {
          text: 'select * from one_version_0_0_1.signin($1,$2)',
          values: [token, JSON.stringify(req.payload)]
        }
      );
      result = res.rows[0].signin;
    } catch (err) {
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      //console.log('time err', err)
    } finally {
      client.release();
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
            scope: ['guest']
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
