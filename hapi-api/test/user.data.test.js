import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}

import { init } from '../lib/server.js';
import Jwt from '@hapi/jwt';
import TestData from './test_data.js';
import { Password } from '../lib/password.js';
import DBClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js'
describe('Convert users ', () => {
  let server = null;

  beforeAll(async () => {

      server = await init();

  });

  afterAll(async () => {
     //console.log('restricted server stop');
      await server.stop();

  });

  it('/user : bad User passwords (POST), response 200', async () => {
      // Goal: Add application user
      // Strategy: only guest token can add user
      //           set validation in route route.options.auth
      let secret = process.env.LB_JWT_SECRET;
      //let payload = new TestData().guest_TokenPayload();
      //let token = 'Bearer ' + Jwt.token.generate(payload, secret);

      let client = new DBClient().connect();
      let foundbad = false;
      for(let i in client.table.table){
        if (client.table.table[i].sk === 'USER') {
          if ( typeof(client.table.table[i].form.password) === 'string' ){
            let j = new UserChelate(client.table.table[i].form).toJson();
            console.log(JSON.stringify(j));
            foundbad = true;
          }
        }
      }
      expect(foundbad).toBeFalsy();

  });


});
