import { Client } from 'pg';
import { CriteriaBest } from '../criteria.js';
import { CriteriaPK } from '../criteria.js';

export default class DbClientPostgres extends Client {
  // always starts with an empty table

  constructor (config) {
    super(config);
    this.guest_token = config.guest_token;
    //console.log('DbClientPostgres config',config);
  }
  async startTransaction(){
    //await client.query('BEGIN');
    await super.query('BEGIN');
  }
  async rollbackTransaction(){
    //await client.query('ROLLBACK');
    await super.query('ROLLBACK');

  }
  async commitTransaction() {
    //await client.query('COMMIT');
    await super.query('COMMIT');

  }
  endTransaction() {
    super.release();
  }
  /*
    try{
      await this.startTransaction();
      await this.query(some quer str);
      await this.commitTransaction();
    } catch(e){
      await this.rollbackTransaction();
    } finally {
       this.releaseTransaction();
    }
  }
  */
  /*
  environment:
      - PGHOST: 'db'
      - PGDATABASE: 'postgres'
      - PGUSER: 'postgres'
      - PGPASSWORD: 'postgres'
  */
  async query(select_criteria) {
    let result = [];
    let error;
    let status = '200';
    let msg = 'OK';
    try {
      // validate criteria
      let criteriaBest = new CriteriaBest(select_criteria);// throws exceptions
      let query = {
        text: 'select * from one_version_0_0_1.query($1)',
        values: [JSON.stringify(criteriaBest)]
      };
      let res = await super.query(query);
      result = res.rows.map((result) => {delete result.results.form['password']; return result.results;});
//console.log('query result', result);
//console.log('query result.length', result.length);
//console.log('query typeof(result.selection)', typeof(result.selection));

      if (result.length === 0) {
        status = '404';
        msg = 'Not Found';
      }
    } catch(e) {
      error = e.message;
      if (error === 'Missing Criteria') {
        status = '400';
        msg = 'Bad Request';
      } else if (error === 'Must initialize Criteria with object.') {
        status = '400';
        msg = 'Bad Request';
      }
      //console.log('query error ', e);
    } finally{
      let selection = {status:status, msg:msg, criteria: select_criteria, selection: result};
      if(error) {
        selection.error=error;
      }
      return selection;
    }
  }
  /*
    async query(select_criteria) {
      await this.connect();

      //let res = await this.query('SELECT $1::text as message', ['Hello world!']);
      let res = await this.query('Select NOW()');
      //console.log('res', res);
      //await this.end() ;
        client.release();
      return res;

    }
  */
  async delete(delete_criteria) {
   let result = {};
   let error;
   let cnt = 0;
   let msg = 'OK';
   let status = '200';
   try {
     //await this.startTransaction();

     // already connected
     let criteriaPK = new CriteriaPK(delete_criteria);
     let del = {
       text: 'select * from one_version_0_0_1.delete($1)',
       values: [JSON.stringify(criteriaPK)]
     };
     // query is the correct call
     let res = await super.query(del);

     result = JSON.parse(JSON.stringify(res.rows[0].delete.deletion));
     //await this.commitTransaction();
     //console.log('result ', result);
     //console.log('result.msg ', result['msg']);
     if (result['msg']) {
       msg = 'Not Found';
       status = '404';
     }
     //console.log('delete out');
   } catch(e) {
     //console.error(e);
     error = {msg:e.message};
     //this.rollbackTransaction();
   } finally {
     let deletion = {status: status, msg:msg, criteria: delete_criteria, deletion: result};
     if(error) {
       deletion.error=error;
     }
     ////this.releaseTransaction();
     return deletion;
   }
  }

  async insert(chelate) {
    let result = {};
    let error;
    let status = '200';
    let msg = 'OK';
    let insertion = {};
    try {
      //await this.startTransaction();

      //console.log('insert 1');
      //console.log('insert 1', chelate);
      // validate JWT

      // validate chelate
      if ( !(chelate.sk && chelate.form) ) {
        status = '400';
        msg = 'Bad Request';
        throw Error('Bad Request');
      }
      // prepare insert
      let ins = {
        text: 'select * from one_version_0_0_1.insert($1)',
        values: [JSON.stringify(chelate)]
      };
      // query is the correct call
      let res = await super.query(ins);
      //console.log('client res', res);
      //console.log('client res.rows[0]', JSON.parse(JSON.stringify(res.rows[0])) );
      //console.log('client res.rows[0].insert.insertion', JSON.parse(JSON.stringify(res.rows[0].insert.insertion)) );

      status = res.rows[0].insert.status;
      //console.log('status',status);
      msg = res.rows[0].insert.msg;
      //console.log('msg',msg);

      insertion = JSON.parse(JSON.stringify(res.rows[0].insert.insertion));
      //console.log('insertion', insertion);
      //await this.commitTransaction();

    } catch (e) {
       result['error']=e.message;
       //this.rollbackTransaction();

    } finally {
      //this.releaseTransaction();

      return {status: status, msg: msg, insertion: insertion};
    }

  }

  async update(chelate) {
    // update by primary key, pk and sk
    let result = {};
    let error;
    let status = '200';
    let msg = 'OK';
    try {
      //await this.startTransaction();

      //console.log('update 1');
      //console.log('pk', !(update_chelate.pk));
      if ( !(chelate.pk && chelate.sk && chelate.form) ) {
        status = '400';
        msg = 'Bad Request';
        throw Error(msg);
      }
      //console.log('update 2');

      // prepare insert
      let upd = {
        text: 'select * from one_version_0_0_1.update($1)',
        values: [JSON.stringify(chelate)]
      };
      //console.log('update 3');
      // query is the correct call
      let res = await super.query(upd);
      //console.log('update 4');
      //console.log('client res', res);
      //console.log('client res.rows[0]', JSON.parse(JSON.stringify(res.rows[0])) );
      status = res.rows[0].update.status;
      msg = res.rows[0].update.msg;
      //await this.commitTransaction();

    } catch (e) {
      //console.log('update 5');
      msg = e.message;
       if (e.message === 'Bad Request') {
         status = '400';
       } else if(e.message === 'Not Found'){
         status = '404';
       } else {
         status = '500';
       }
       result['error']=e.message;
       //this.rollbackTransaction();

    } finally {
      //console.log('update out');
      //this.releaseTransaction();

      return {status: status, msg: msg};
    }
  }
  set(name, value) {

  }
  async signin(credentials) {
    let result = {};
    let error;
    let status = '200';
    let msg = 'OK';
    let token;
    try {
      if ( !this.guest_token || !credentials ) {
        status = '403';
        msg = 'Forbidden';
        throw Error(msg);
      }
      /*
      let set = {
        text: 'select * ($1,$2)',
        values: [this.getGuestToken(),JSON.stringify(credentials)]
      };
      */
      let sin = {
        text: 'select * from one_version_0_0_1.signin($1,$2)',
        values: [this.guest_token,JSON.stringify(credentials)]
      };

      let res = await super.query(sin);

      status = res.rows[0].signin.status;
      msg = res.rows[0].signin.msg;
    } catch (e) {
      msg = e.message;
       if (e.message === 'Bad Request') {
         status = '400';
       } else if(e.message === 'Forbidden') {
         status = '403';
       } else if(e.message === 'Not Found'){
         status = '404';
       } else {
         console.log('e.message',e.message);
         status = '500';
       }
       token = '';
       result['error']=e.message;
    } finally {
      return {status: status, msg: msg, token: token};
    }
  }
  /*


  ////////////
  // SignUp
  ///////////
  signup(credentials) {

    let insertResponse = this.insert(new ChelateUser(credentials));

    return insertResponse;
  }
  /////////////
  // SignIn
  /////////////
  signin(credentials) {
    // credentials is dont contain value prefix, eg a@a.com instead of username:a@a.com
    let criteria = {pk: `username#${credentials.username}`, sk: 'const#USER'}; // config search for user
    let selection = this.select(criteria); // get users recorded account
    //console.log('selection', selection);
    let authentication = false; // assume attempt will fail

    if (selection.selection.length > 0) {
      let selection_password = selection.selection[0].form.password; // users recorded password
      let secret = process.env.LB_JWT_SECRET;
      let guest_payload = new TokenPayload()
                          .payload();

      if (new Password().verify(credentials.password, selection_password)){
        let token = 'Bearer ' + Jwt.token.generate(guest_payload, secret);
        authentication = {token: token};
      }
    }
    delete credentials['password'];

    return {credentials: credentials, authentication: authentication};
  }
*/
}
