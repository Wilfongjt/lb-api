module.exports = {
  // [Route: /restricted]
  // [Description: Example of a JWT restricted route]
  method: 'GET',
  path: '/restricted',
  handler: async function (req,h) {
    // [Define a /restricted route handler]
    let result = {status:"200", msg:"OK"};
    return result;
  },
  options: {
    // [Configure JWT authorization strategy]
    auth: 'lb_jwt_strategy',
    description: 'API Restricted',
    notes: 'Returns ',
    tags: ['api']
  }
};
