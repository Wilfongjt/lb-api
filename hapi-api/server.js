'use strict';
import dotenv from 'dotenv';
console.log('starting');
if (process.env.NODE_ENV !== 'production') {
  console.log('loading environment');
  process.env.DEPLOY_ENV=''
  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../.env') });
}
// this setup enables testing
const { start } = require('./lib/server');

start();
