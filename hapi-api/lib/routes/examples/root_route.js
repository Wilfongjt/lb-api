module.exports = {
  // [Route: / ]
  // [Description: Example of how to handle route to the root of API]
  method: 'GET',
  path: '/',
  handler: async function (req,h) {
    // [Define a / route handler]
    let result = {status:"200", msg:"OK"};
    return result;
  },
  options: {
    // [Configure / route options]
    auth: false,
    description: 'API Root',
    notes: 'Returns ',
    tags: ['api']
  }
};
