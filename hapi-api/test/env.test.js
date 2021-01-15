import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

describe('JSON Environment Vars', () => {
  test('NODE_ENV Environment Variable', () => {
    //console.log('process.env',process.env);
    expect(process.env.NODE_ENV).toBeDefined();
  })

});

// - NODE_ENV=${NODE_ENV}
//- JSON_DB=${JSON_DB}
//- JSON_DB_PORT=${JSON_DB_PORT}
//- JSON_DB_HOST=${JSON_DB_HOST}
//- JSON_DB_USER=${JSON_DB_USER}
//- JSON_DB_PASSWORD=${JSON_DB_PASSWORD}
//- JSON_DB_JWT_SECRET=${JSON_DB_JWT_SECRET}
/*
- JSON_DB_JWT_CLAIMS=${JSON_DB_JWT_CLAIMS}
- JSON_DB_GUEST=${JSON_DB_GUEST}
- JSON_DB_GUEST_TOKEN=${JSON_DB_GUEST_TOKEN}
*/
describe('LB Environment Vars', () => {

  test('LB_API_PORT Environment Variable', () => {
    expect(process.env.LB_API_PORT).toBeDefined();
  })

  test('LB_API_HOST Environment Variable', () => {
    expect(process.env.LB_API_HOST).toBeDefined();
  })

  test('LB_JWT_SECRET Environment Variable', () => {
    expect(process.env.LB_JWT_SECRET).toBeDefined();
  })
  
});
/*
describe('JSON DB Environment Vars', () => {

  test('JSON_DB Environment Variable', () => {
    expect(process.env.JSON_DB).toBeDefined();
  })

  test('JSON_DB_PORT Environment Variable', () => {
    expect(process.env.JSON_DB_PORT).toBeDefined();
  })
  test('JSON_DB_HOST Environment Variables', () => {
    expect(process.env.JSON_DB_HOST).toBeDefined();
  })
  test('JSON_DB_USER Environment Variables', () => {
    expect(process.env.JSON_DB_USER).toBeDefined();
  })
  test('JSON_DB_PASSWORD Environment Variables', () => {
    expect(process.env.JSON_DB_PASSWORD).toBeDefined();
  })
  test('JSON_DB_JWT_SECRET Environment Variables', () => {
    expect(process.env.JSON_DB_JWT_SECRET).toBeDefined();
  })
  test('JSON_DB_JWT_CLAIMS Environment Variables', () => {
    expect(process.env.JSON_DB_JWT_CLAIMS).toBeDefined();
  })

});
*/
