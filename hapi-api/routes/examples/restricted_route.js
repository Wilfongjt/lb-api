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
