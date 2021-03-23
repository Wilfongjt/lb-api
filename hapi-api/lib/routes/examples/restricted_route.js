module.exports = {
  method: 'GET',
  path: '/restricted',
  handler: async function (req,h) {
    let result = {status:"200", msg:"OK"};
    return result;
  },
  options: {
    auth: 'lb_jwt_strategy',
    description: 'API Restricted',
    notes: 'Returns ',
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
