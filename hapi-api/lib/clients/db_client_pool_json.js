import DbClientJson from './db_client_json.js';
export default class DbClientPoolJSON {

  constructor (config) {
    //super(config, Client);
    this.config = config;
  }

  async connect() {
    return Promise.resolve(new DbClientJSON(this.config));
  }

  async end() {
    return Promise.resolve('end');
  }

}
