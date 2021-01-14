
if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''
  require('dotenv').config({path: '../.env'});
}
describe('Environment Vars', () => {
  test('NODE_ENV Environment Variable', () => {
    expect(process.env.NODE_ENV).toBeDefined();
  })
  test('LB_API_PORT Environment Variables', () => {
    expect(process.env.LB_API_PORT).toBeDefined();
  })
  test('LB_API_HOST Environment Variables', () => {
    expect(process.env.LB_API_HOST).toBeDefined();
  })
  test('LB_SECRET Environment Variables', () => {
    expect(process.env.LB_SECRET).toBeDefined();
  })
  test('LB_API_TOKEN Environment Variables', () => {
    expect(process.env.LB_API_TOKEN).toBeDefined();
  })
  test('LB_JWT_CLAIMS Environment Variables', () => {
    expect(process.env.LB_JWT_CLAIMS).toBeDefined();
  })
  test('LB_BACKEND Environment Variables', () => {
    expect(process.env.LB_BACKEND).toBeDefined();
  })
});
