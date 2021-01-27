module.exports = {
  method: 'GET',
  path: '/',
  handler: (req, h) => ({
    message: 'Hello Hapi.js',
    routes: [process.env.LB_API_PORT] 
  }),
  /*handler: function (req, h) {
    // let client = new DbClient().connect();
    // let insertResponse = client.insert(new UserChelate(req.payload));

    return '/';
  },*/
  options: {
       auth: false
  }
}
