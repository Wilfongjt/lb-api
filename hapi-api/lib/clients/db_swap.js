/*
import DBClientPostgres from './db_client_postgres.js'

export default class DbClientRouter extends DBClientPostgres {
  constructor(config){
    super(config);
  }
}
*/

import DbClientJSON from './db_client_json.js';
import DbClientPoolJSON from './db_client_pool_json.js';

export class DbClientSwap extends DbClientJSON {
  constructor(config){
    super(config);
  }
};

export class DbPoolSwap extends DbClientPoolJSON {
  constructor(config){
    super(config);
  }
};
