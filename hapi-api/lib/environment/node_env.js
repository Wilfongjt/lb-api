import { EnvConfig } from './env_config.js';

export class NodeEnv extends EnvConfig {
  constructor() {
    super('NODE_');
  }
};
