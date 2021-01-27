
import DbClientConfig from './db_client_config.js';
import Chelate from './chelate.js'
//const jsonQuery = require('json-query');
import jsonQuery from 'json-query';
import DataTypes from '../lib/data_types.js';
// insert {pk:null, sk, data:null, form, ...}
//
//
export default class DbClient {
  // always starts with an empty table
  // connect clears the table
  constructor () {
    //console.log('db client ');
    this.table = {
      "table": []
    };
    this.config = new DbClientConfig();
  }

  connect() {
    //console.log('connect', this.config);
    if (!this.config.path){
      throw new Error('Missing path value');
    }
    if (this.table !== null) {
      // load json default data
      this.table = JSON.parse(JSON.stringify(require(this.config.path)));
      /*this.table = {
        "table": []
      };
      */
    }
    return this;
  }


  select(criteria) { //
    // {pk:"*", sk:"*"}
    // {sk:"*", tk:"*"}

    let result = [];
    let error;
    if (typeof(criteria)==='string') {

      return {criteria: criteria, selection: this.table.table};
    }

    for (let i in this.table.table) {

      let item = this.table.table[i];
      if (criteria.pk && criteria.sk ) {
        if(item.pk === criteria.pk && item.sk === criteria.sk){
          result.push(this.table.table[i]);
          //result.push(i);
        }
      } else if (criteria.sk && criteria.tk) {
        if(item.sk === criteria.sk && item.tk === criteria.tk){
          result.push(this.table.table[i]);
          //result.push(i);
        }
      } else if(criteria.sk) {
        if(item.sk === criteria.sk ){
          result.push(this.table.table[i]);
          //result.push(i);
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

      //try {
        let item = chelate.toJson();
        if (!item.pk) {
          throw new Error('Missing pk value');
        }
        if (!item.sk) {
          throw new Error('Missing sk value');
        }
        if (!item.tk) {
          throw new Error('Missing tk value');
        }

        if (!this.table) {
          throw new Error('Not connected to data');
        }

        if (!item['dups'] || !item.dups) {

          let finding = this.select({pk:item.pk, sk:item.sk});
          if (finding.selection.length > 0) { // duplicate
            return {isValid: false, error: 'Duplicate not allowed!'};
          }
        }

        //console.log('insert', JSON.stringify(item));
        this.table.table.push(item);
        // insertResponse
        return {isValid: true, result: item};
  }

  delete(criteria) {
    let result=[];
    let error;

    //if (typeof(criteria)==='string') {
    //  return {criteria: criteria, selection: this.table.table};
    //}
    //console.log('criteria.pk',criteria.pk,'criteria.sk',criteria.sk,'criteria.tk',criteria.tk);

    for (let i in this.table.table) {

      let item = this.table.table[i];
      if (criteria.pk && criteria.sk ) {
        if(item.pk === criteria.pk && item.sk === criteria.sk){
          //console.log('delete A', this.table.table.length);
          result.push(JSON.parse(JSON.stringify(item)));
          //result = JSON.parse(JSON.stringify(this.table.table[i]));
          delete this.table.table.splice(i,1);
          //console.log('delete A1', this.table.table.length);

        }
      } else if (criteria.sk && criteria.tk) {
        if(item.sk === criteria.sk && item.tk === criteria.tk){
          //console.log('delete B');
          result.push(JSON.parse(JSON.stringify(item)));
          delete this.table.table.splice(i,1);

        }
      } else if(criteria.sk) {
        if(item.sk === criteria.sk ){
          //console.log('delete C');
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

  getCriteria(item) {
    let criteria= {};
    if (item.pk){
      criteria.pk = item.pk;
    }
    if ( item.sk ) {
      criteria.sk = item.sk;
    }
    if ( item.tk ) {
      criteria.tk = item.tk;
    }
    return criteria;
  }
  mergeHot(fr, to) {
    // merges "fr" into "to"
    // will add "fr" attributes that are not in "to"
    // will not remove attributes in "to" that are not in "fr"
    let result = to;
    for (let nm in fr) {
      //console.log('nm', nm);
       if (nm !== 'form'){
         result[nm] = fr[nm];
       }
    }
    if (fr['form']) {
      for (let key in fr.form) {
        result['form'][key] = fr['form'][key];
      }
    }
    return result;
  }
  mergeCopy(fr, to) {
    // merges "fr" into a copy of "to"
    // will add "fr" attributes that are not in "to"
    // will not remove attributes in "to" that are not in "fr"
    let cpy = JSON.parse(JSON.stringify(to));
    return this.mergeHot(fr,cpy );
    /*for (let nm in fr) {
      //console.log('nm', nm);
       if (nm !== 'form'){
         result[nm] = fr[nm];
       }
    }
    if (fr['form']) {
      for (let key in fr.form) {
        result['form'][key] = fr['form'][key];
      }
    }
    return result;
    */
  }

  update(upd_item) {
    // upd_item = {pk:*, sk:* form: {}} || {sk:*, tk:*, form:{}}
    // create criteria from upd_item: {pk:*, sk:*} || {pk:*, sk:*}
    // find old-item using criteria
    // merge the upd-item and old_item into new-item
    // delete old-item from table
    // add updated attribute to new-item
    // insert new_item into table
    // return {{pk:*, sk:*, tk:*, form:{}, created: *, updated:*}}
    // returns {criteria: criteria, updates: result};

    let _datetime = new Date();
    let result = [];
    let error;
    let criteria=this.getCriteria(upd_item);
    let selectionResult = this.select(criteria);
    let old_item = selectionResult.selection[0];
    let new_item = this.mergeCopy(upd_item, old_item);

    result = this.delete(criteria);

    result = JSON.parse(JSON.stringify(result.deletion));
    new_item.updated = new Date();
    this.table.table.push(new_item);

    let updates = {criteria: criteria, updates: result};
    if (error) {
      updates.error = error;
    }

    return updates;
  };

}

//export default class { DbClient };
//module.exports = DbClient;
