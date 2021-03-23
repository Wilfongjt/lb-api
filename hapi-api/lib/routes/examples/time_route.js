'use strict';
/* return the time on the database server */
module.exports = {
  method: 'GET',
  path: '/time',
  handler: async function (req,h) {
    let result = {status:"200", msg:"OK"};
    let client ;
    try {
      client = req.pg;

      let res = await client.query(
        {
          text: 'select * from one_version_0_0_1.time()'
        }
      );
      //console.log('time res',res);
      result = res.rows[0].time;

    } catch (err) {
      result.status = '500';
      result.msg = 'Unknown Error'
      result['error'] = err;
      console.log('/time err', err)
    } finally {
      client.release();
      return result;
    }
  },
  options: {
    auth: 'lb_jwt_strategy',
    description: 'API Time',
    notes: 'Returns the server time.',
    tags: ['api']
  }
};

/*
module.exports = {
  method: 'GET',
  path: '/restricted',

  options: {
        description: 'Restricted access',
        notes: 'Returns ',
        tags: ['api'],
        handler: (req, h) => ({ message: 'List Hapi.js' })
  }
}
*/
