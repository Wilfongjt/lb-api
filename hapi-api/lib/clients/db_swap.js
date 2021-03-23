// DEPRECATED

/*
import DBClientPostgres from './db_client_postgres.js'

export default class DbClientRouter extends DBClientPostgres {
  constructor(config){
    super(config);
  }
}
*/
/*
                  + --- DbClientJSON
                  |
DbClientSwap <--- + --- DbClientPostgres

                  + --- DbClientPoolJSON
                  |
DbRouterSwap <--- + --- DbClientPoolPostgress

*/

/*
// JSON File
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
*/
/*
// Postgres Database

import DbClientJSON from './postgres/db_client_postgres.js';
import DbClientPoolJSON from './postgres/db_client_pool_postgres.js';

export class DbClientSwap extends DbClientPostgres {
  constructor(config){
    super(config);
  }
};

export class DbPoolSwap extends DbClientPoolPostgres {
  constructor(config){
    super(config);
  }
};
*/
