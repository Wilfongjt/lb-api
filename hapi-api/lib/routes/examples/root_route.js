module.exports = {
  method: 'GET',
  path: '/',
  handler: async function (req,h) {
    let result = {status:"200", msg:"OK"};
    return result;
  },
  options: {
    auth: false,
    description: 'API Root',
    notes: 'Returns ',
    tags: ['api']
  }
};
/*
module.exports = {
  method: 'GET',
  path: '/',
  options: {
      description: 'API Root',
      notes: 'Returns ',
      tags: ['api'],
      handler: (req, h) => ({
        message: 'Hello Hapi.js',
        routes: [process.env.LB_API_PORT]
      }),
      auth: false
  }
}
*/
