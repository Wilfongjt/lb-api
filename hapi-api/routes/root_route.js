module.exports = {
  method: 'GET',
  path: '/',

  /*handler: function (req, h) {
    // let client = new DbClient().connect();
    // let insertResponse = client.insert(new ChelateUser(req.payload));

    return '/';
  },*/
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
