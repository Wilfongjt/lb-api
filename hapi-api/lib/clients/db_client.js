deprecated

import jsonQuery from 'json-query';
import Jwt from '@hapi/jwt';

import DbClientConfig from './db_client_config.js';

import Chelate from '../chelates/chelate.js'
import { ChelatePattern } from '../chelates/chelate_pattern.js'
import { ChelateUser } from '../chelates/chelate_user.js';
import { ChelateHelper } from '../chelates/chelate_helper.js'

import DataTypes from '../constants/data_types.js';

import TokenPayload  from '../auth/token_payload.js';
import { Password } from '../auth/password.js';

import { CriteriaBest } from '../clients/criteria.js';
import { CriteriaPK } from '../clients/criteria.js';
// insert {pk:null, sk, data:null, form, ...}
//
//
export default class DbClient {
  // always starts with an empty table
  // connect clears the table
  constructor () {
    //console.log('db client ');
    /*
    this.table = {
      "table": []
    };
    this.config = new DbClientConfig();
    */
  }

  connect() {
    throw new Error('Child class of DBClient is missing a connect() method.');
    //console.log('connect', this.config);
    /*
    if (!this.config.path){
      throw new Error('Missing path value');
    }
    if (this.table !== null) {
      // load json default data
      this.table = JSON.parse(JSON.stringify(require(this.config.path)));

    }
    */
    return this;
  }

  disconnect() {
    throw new Error('Child class of DBClient is missing a disconnect() method.');

  }


  select(select_criteria) { //
    // {pk:"*", sk:"*"}
    // {sk:"*", tk:"*"}
    throw new Error('Child class of DBClient is missing a select(select_criteria) method.');

    /*
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
    */

    return selection;
  }

  insert(chelate) {
    throw new Error('Child class of DBClient is missing a insert(chelate) method.');
    /*
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
    */
    //return {insertion: chelate_copy};

  }


  delete(criteria) {
    throw new Error('Child class of DBClient is missing a delete(criteria) method.');

    /*
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
    */
    //return deletion;
  }

  update(update_chelate) {
    throw new Error('Child class of DBClient is missing a update(update_chelate) method.');

    // update current record
    // strategy:  find record,
    //            resolve differences,
    //            delete record,
    //            insert resolved record
    // return record before updated
    /*
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
    */
    //return updates;
  }


  ////////////
  // SignUp
  ///////////
  signup(credentials) {
    throw new Error('Child class of DBClient is missing a signup(credentials) method.');

    /*
    let insertResponse = this.insert(new ChelateUser(credentials));

    return insertResponse;
    */
  }
  /////////////
  // SignIn
  /////////////
  signin(credentials) {
    throw new Error('Child class of DBClient is missing a signin(credentials) method.');
    /*
    // credentials is dont contain value prefix, eg a@a.com instead of username:a@a.com
    let criteria = {pk: `username#${credentials.username}`, sk: 'const#USER'}; // config search for user
    let selection = this.select(criteria); // get users recorded account
    //console.log('selection', selection);
    let authentication = false; // assume attempt will fail

    if (selection.selection.length > 0) {
      let selection_password = selection.selection[0].form.password; // users recorded password
      let secret = process.env.LB _JWT_SECRET;
      let guest_payload = new TokenPayload()
                          .payload();

      if (new Password().verify(credentials.password, selection_password)){
        let token = 'Bearer ' + Jwt.token.generate(guest_payload, secret);
        authentication = {token: token};
      }
    }
    delete credentials['password'];

    return {credentials: credentials, authentication: authentication};
    */
  }

}
