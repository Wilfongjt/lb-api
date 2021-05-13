'use strict';
import dotenv from 'dotenv';
console.log('starting');
if (process.env.NODE_ENV !== 'production') {
  console.log('loading environment');
  process.env.DEPLOY_ENV=''
  const path = require('path');
  //console.log('__dirname',__dirname)
  dotenv.config({ path: path.resolve(__dirname, '../.env') });
  //console.log('init env',process.env);
  //console.log('LB _JWT_CLAIMS',typeof(process.env.LB _JWT_CLAIMS))
}
// this setup enables testing
const { start } = require('./lib/server');

start();
