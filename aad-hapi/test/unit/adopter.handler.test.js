const Handler = require('');
if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''
  require('dotenv').config({path: '../.env'});
}
describe('Environment Vars', () => {

  test('Environment Variables', () => {
    expect(process.env.NODE_ENV).toBeDefined();
    expect(process.env.LB_API_PORT).toBeDefined();
    expect(process.env.LB_API_HOST).toBeDefined();
    expect(process.env.LB_SECRET).toBeDefined();
    expect(process.env.LB_API_TOKEN).toBeDefined();
    expect(process.env.LB_JWT_CLAIMS).toBeDefined();
  })
});
