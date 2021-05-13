import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
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

  test('API_PORT Environment Variable', () => {
    expect(process.env.API_PORT).toBeDefined();
  })

  test('API_HOST Environment Variable', () => {
    expect(process.env.API_HOST).toBeDefined();
  })

  test('API_JWT_SECRET Environment Variable', () => {
    expect(process.env.API_JWT_SECRET).toBeDefined();
  })

  test('API_GUEST_TOKEN Environment Variable', () => {
    expect(process.env.API_GUEST_TOKEN).toBeDefined();
  })

  test('API_DB_CONFIG Environment Variable', () => {
    expect(process.env.API_DB_CONFIG).toBeDefined();
  })

  test('API_DB_USER_CONFIG Environment Variable', () => {
    expect(process.env.API_DB_USER_CONFIG).toBeDefined();
  })
  
  test('API_JWT_CLAIMS Environment Variable', () => {
    expect(process.env.API_JWT_CLAIMS).toBeDefined();
  })
  /*
  test('DATABASE_URL Environment Variable', () => {
    expect(process.env.DATABASE_URL).toBeDefined();
  })*/
});
/*
these are no longer in the api
describe('POSTGRES_JWT_CLAIMS Environment Var', () => {
  test('POSTGRES_DB Environment Variable', () => {
    expect(process.env.POSTGRES_DB).toBeDefined();
  })
  test('POSTGRES_USER Environment Variable', () => {
    expect(process.env.POSTGRES_USER).toBeDefined();
  })
  test('POSTGRES_PASSWORD Environment Variable', () => {
    expect(process.env.POSTGRES_PASSWORD).toBeDefined();
  })
  test('POSTGRES_JWT_SECRET Environment Variable', () => {
    expect(process.env.POSTGRES_JWT_SECRET).toBeDefined();
  })
  test('POSTGRES_API_PASSWORD Environment Variable', () => {
    expect(process.env.POSTGRES_API_PASSWORD).toBeDefined();
  })
  test('POSTGRES_JWT_CLAIMS Environment Variable', () => {
    expect(process.env.POSTGRES_JWT_CLAIMS).toBeDefined();
    let claims = JSON.parse(process.env.POSTGRES_JWT_CLAIMS);
    expect(claims.aud).toBeDefined();
    expect(claims.iss).toBeDefined();
    expect(claims.sub).toBeDefined();
    expect(claims.user).toBeDefined();
    expect(claims.scope).toBeDefined();
    expect(claims.key).toBeDefined();
  })

});
*/
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
