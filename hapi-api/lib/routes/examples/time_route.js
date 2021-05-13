'use strict';
/* return the time on the database server */
module.exports = {
  // [Route: /time]
  // [Description: Example of calling a function on the database]
  method: 'GET',
  path: '/time',
  handler: async function (req,h) {
    // [Define a /time route handler]

    let result = {status:"200", msg:"OK"};
    let client ;
    try {
      if (! req.pg) {
        throw 'Client not found in request.';
      }
      // [Get a database client]
      client = req.pg;
      // [Query the time]
      let res = await client.query(
        {
          text: 'select * from api_0_0_1.time()'
        }
      );
      result = res.rows[0].time;
    } catch (err) {
      // [Catch any exceptions]
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.log('/time err', err)
    } finally {
      // [Release the client back to the pool]
      if (client) {
        client.release();
      }  else {
        console.log('time_route missing client')
      }
      // [Return the time as JSON]
      return result;
    }
  },
  options: {
    // [Configure JWT authorization strategy]
    auth: 'lb_jwt_strategy',
    description: 'API Time',
    notes: 'Returns the server time.',
    tags: ['api']
  }
};
