import { Pool } from 'pg';

export default class DbClientPoolPostgres extends Pool {

  constructor (config,Client) {
    super(config, Client);
    // the pool will emit an error on behalf of any idle clients
    // it contains if a backend error or network partition happens

    this.on('error', (err, client) => {
      console.error('Unexpected error on idle client', err)
      process.exit(-1)
    })

  }

}
