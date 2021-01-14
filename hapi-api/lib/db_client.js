
import DbClientConfig from './db_client_config.js';

//class DbClient {
//export default class {
export default class DbClient {
  constructor () {
    this.table = {};
    this.config = new DbClientConfig();
  }
  connect() {
    if (!this.config.path){
         throw new Error('Missing path value');
       }
       if (this.table !== null) {
         return {isValid: true, status:"loaded"};
       }
       // load json default data
       this.table = JSON.parse(JSON.stringify(require(this.config.path)));

       return {isValid: true};
  }
  select() {return this.table}
  insert(item) {return item;}
  update(item) {return item;}
  delete(item) {return item;}
}

//export default class { DbClient };
//module.exports = DbClient;
