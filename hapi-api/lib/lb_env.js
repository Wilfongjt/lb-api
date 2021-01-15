import { EnvConfig } from './env_config.js';

export class LbEnv extends EnvConfig {
  constructor() {
    super('LB_');
  }
};
