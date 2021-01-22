export default class DbClientConfig {
  constructor() {
      this.host = process.env.LB_HOST || '0.0.0.0'; // hapi host
      this.port = process.env.LB_PORT || 5555; // hapi port
      this.path = '../data/seed.json';
      /*
      this.user = process.env.JSON_DB_USER || 'json_db';
      this.host = process.env.JSON_DB_HOST || 'localhost';
      this.database = process.env.JSON_DB || 'lb_db';
      this.password = process.env.JSON_DB_PASSWORD || 'mysecretdatabasepassword';
      this.port = process.env.JSON_DB_PORT || 5432;
      this.path = '../data/seed.json';
      this.jwt_secret = process.env.JSON_JWT_SECRET || 'PASSWORDmustBEATLEAST32CHARSLONGLONG';
      this.claims = JSON.parse(process.env.JSON_DB_JWT_CLAIMS || '{"aud": "client-type", "iss": "issuer-name", "sub": "app-name"}');
      this.guest = process.env.JSON_DB_GUEST  || 'guest@guest.com';
      this.scope = ["guest"];
      */
  }
}
//export default class { DbClientConfig };
//module.exports = { DbClientConfig };
//module.exports = DbClientConfig;
