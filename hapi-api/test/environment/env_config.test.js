import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}

import { EnvConfig } from '../../lib/environment/env_config.js';
import { LbEnv } from '../../lib/environment/lb_env.js';
import { NodeEnv } from '../../lib/environment/node_env.js';

describe('EnvConfig', () => {
  test('new EnvConfig', () => {
    let config = new EnvConfig();
    expect(config).toBeDefined();
  })
});

describe('LbEnv', () => {
  test('new LbEnv', () => {
    //console.log('LbEnv', new LbEnv())
    expect(new LbEnv()).toBeDefined();
  })
});

describe('NodeEnv', () => {
  test('new NodeEnv', () => {
    //console.log('NodeEnv', new NodeEnv())
    expect(new NodeEnv()).toBeDefined();
  })
});
