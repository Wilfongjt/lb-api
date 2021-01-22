module.exports = {
  method: 'GET',
  path: '/',
  handler: (req, h) => ({ message: 'Hello Hapi.js' }),
  options: {
       auth: false
  }
}
