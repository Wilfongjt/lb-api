import { Client } from 'pg';
import { CriteriaBest } from '../criteria.js';

export default class DbClientPostgres extends Client {
  // always starts with an empty table

  constructor (config) {
    super(config);
    //console.log('DbClientPostgres config',config);
  }

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

  try {
    //console.log('type', typeof(select_criteria));
    //console.log('select_criteria',select_criteria);

    // validate criteria
    let criteriaBest = new CriteriaBest(select_criteria);// throws exceptions

    //console.log('criteriaBest',criteriaBest);
    let query = {
      text: 'select * from one_version_0_0_1.query($1)',
      values: [JSON.stringify(criteriaBest)]
    };

    let res = await super.query(query);

    //console.log('A res',res);
    //console.log('rows', res.rows);
    result = res.rows.map((result) => {delete result.results.form['password']; return result.results;});

  } catch(e) {
    //console.error(e.stack);
    error = e.message;
  } finally{
    let selection = {criteria: select_criteria, selection: result};
    if(error) {
      selection.error=error;
    }
    //console.log('out *****************');
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
   insert(chelate) {}
   delete(criteria) {}
   update(update_chelate) {}
   signup(credentials) {}
   signin(credentials) {}
/*

  select(select_criteria) { //
    // {pk:"*", sk:"*"}
    // {sk:"*", tk:"*"}
    let result = [];
    let error;
    if (typeof(select_criteria)==='string') {
      return {criteria: select_criteria, selection: this.table.table};
    }

    //let criteria = this.getCriteria(select_criteria);
    let criteria = select_criteria;

    for (let i in this.table.table) { // search for criteria

      let item = this.table.table[i];
      //console.log('item', item);
      if (criteria.pk && criteria.sk ) { // pk sk
        //console.log('select pk && sk');
        if(item.pk === criteria.pk && item.sk === criteria.sk){
          result.push(this.table.table[i]);
        }
      } else if (criteria.sk && criteria.tk) { // sk tk
        if(item.sk === criteria.sk && item.tk === criteria.tk){
          result.push(this.table.table[i]);
        }
      } else if(criteria.sk) { // sk
        if(item.sk === criteria.sk ){
          result.push(this.table.table[i]);
        }
      } else {
        error = 'Missing pk, sk, tk!';
        break;
      }
    }

    let selection = {criteria: criteria, selection: result};
    if (error) {
      selection.error = error;
    }

    return selection;
  }

  insert(chelate) {

    if (!this.table) {
      throw new Error('Not connected to data');
    }
    let chelate_copy = JSON.parse(JSON.stringify(chelate));

    let finding = this.select(new CriteriaPK(chelate_copy));

    if (finding.selection.length > 0) { // duplicate
      return {insertion: false, error: 'Duplicate not allowed!'};
    }

    this.table.table.push(chelate_copy);

    // insertResponse
    return {insertion: chelate_copy};
  }


  delete(criteria) {
    let result=[];
    let error;

    for (let i in this.table.table) {

      let item = this.table.table[i];
      if (criteria.pk && criteria.sk ) { // PK and SK
        if(item.pk === criteria.pk && item.sk === criteria.sk){
          result.push(JSON.parse(JSON.stringify(item)));
          delete this.table.table.splice(i,1);
        }
      } else if (criteria.sk && criteria.tk) { // SK and TK
        if(item.sk === criteria.sk && item.tk === criteria.tk){
          result.push(JSON.parse(JSON.stringify(item)));
          delete this.table.table.splice(i,1);

        }
      } else if(criteria.sk) { // SK only
        if(item.sk === criteria.sk ){
          result.push(JSON.parse(JSON.stringify(item)));
          delete this.table.table.splice(i,1);
        }
      } else {
        //throw new Error('Missing pk, sk, or tk!');
        error = 'Missing pk, sk, tk!';
        break;
      }

    }

    let deletion = {criteria: criteria, deletion: result};
    if (error) {
      deletion.error = error;
    }

    return deletion;
  }

  update(update_chelate) {
    // update current record
    // strategy:  find record,
    //            resolve differences,
    //            delete record,
    //            insert resolved record
    // return record before updated
    let chelateHelper = new ChelateHelper();
    let result = [];
    let criteria = JSON.parse(JSON.stringify(new CriteriaBest(update_chelate))); // use to find record and as part of return
    let selectionResult = this.select(criteria); // find diff

    let cur_chelate = selectionResult.selection[0];
    let result_value = JSON.parse(JSON.stringify(cur_chelate)) ;
    if (result_value.form.password) {
      delete result_value.form.password;
    }
    result.push(result_value); // prepare return
    // resolve differences
    let resolved_chelate = chelateHelper.resolve(cur_chelate, update_chelate);
    this.delete(criteria); // delete existing record
    this.insert(resolved_chelate); // insert the resolve record

    // format return
    let updates = {criteria: criteria, updates: result};
    //if (error) {
    //  updates.error = error;
    //}
    return updates;
  }

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
