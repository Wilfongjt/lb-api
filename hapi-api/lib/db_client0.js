
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
    let qst;
    let q="";
    if (typeof(criteria)==='string') {
      qst = "table[*]";
    } else {

      if(criteria.pk) {
        q = 'pk=%s'.replace('%s',criteria.pk);
      }
      if (criteria.sk) {
        if (q.length===0) {
          q = 'sk=%s'.replace('%s',criteria.sk);
        } else {
          q += ' & sk=%s'.replace('%s',criteria.sk);
        }
      }
      if (criteria.tk) {
        q += ' & tk=%s'.replace('%s',criteria.tk);
      }
      if (q.length === 0) {
        throw new Error("Missing keys pk, sk and tk");
      }
      qst = 'table[%s]'.replace('%s',q);

    }
    console.log('qst', qst);
    let result = jsonQuery(qst, {
      data: this.table
    });

    result = result.value;
    //console.log('typeof', typeof(result));
    //console.log('instanceof ', result instanceof Array);
    //console.log('instanceof ', result instanceof Object);
    if (result === null) {
      result = {criteria: criteria, selection: []};
    } else if (result instanceof Array){
      result = {criteria: criteria, selection: result};
    } else {
      result = {criteria: criteria, selection: [result]};
    }

    return result;
    //return {isValid: true, result: result};
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

        let finding = this.select({pk:item.pk, sk:item.sk});
        console.log('finding', finding);
        if (finding.selection.length !== 0) { // duplicate
          return {isValid: false, result: finding};
        }
        //console.log('insert', JSON.stringify(item));
        this.table.table.push(item);
        // insertResponse
        return {isValid: true, result: item};
  }

/*
  //update(form) {return form;}
  update(chelate) {
    // sk = type
    // data = id
    console.log('update 1', chelate);
    let item = chelate.toJson();
    let _datetime = new Date();
    // update wrapper changed attributes
    // skip missing wrapper attributes
    // update form attributes
    // add new attributes
    //console.log('update 2');

    //console.log('update 3');

    if (!item.sk) {
      throw new Error('Missing sk value');
    }
    //console.log('update 4');

    if (!item.tk) {
      throw new Error('Missing data value');
    }
    //console.log('update 5');

    if (!this.table) {
      throw new Error('Not connected to data');
    }
    //console.log('update 6');

    // look for duplicate
    let qst = 'table[sk=%s & data=%s]'
                .replace('%s',item.sk)
                .replace('%s',item.tk);

    //console.log('update 7');
console.log('qst', qst);
    let result = jsonQuery(qst, {
      data: this.table
    });
    console.log('update 8');

//console.log('result',result);
    if (! result.value) {
      throw new Error('Update %s %s not found'.replace('%s',item.sk).replace('%s',item.tk));
    }
    //console.log('update 9');

    let found_key = result.key;
    let changed = false;

//console.log('found_key', found_key);
//console.log('update 10');

    for (let name in item) {
  //    console.log('item[name]', item[name]);
      if (typeof(item[name]) === 'object') {
        //console.log('object', name);
        for (let key in item[name]) {
          //console.log('object', name, key, item[name][key], ' -- ',found_key, name, key, this.table.table[found_key][name][key] );
          if (item[name][key] !== this.table.table[found_key][name][key]) {
            //console.log('object', found_key, name, key, this.table.table[found_key][name][key], ' -- ',name, key, item[name][key] );
            this.table.table[found_key][name][key] = item[name][key] ;
            changed = true;
          }
        }
      } else {
    //    console.log('not object', found_key, name, this.table.table[found_key][name],' --- ', name, item[name]);

        // is diff
        if (item[name] !== this.table.table[found_key][name]) {
      //    console.log('CHANGE object', found_key, name, this.table.table[found_key][name],' --- ', name, item[name]);

          this.table.table[found_key][name] = item[name] ;
          changed = true;
        }
      }
    }
    //console.log('update 11');

    //console.log('return',this.table.table[found_key]);
    if (changed) {
       this.table.table.[found_key]['updated'] = _datetime;
    }
    //console.log('update out');

    return {isValid: true, result: JSON.parse(JSON.stringify(this.table.table[found_key]))};
  };

  delete(form) {return form;}
  */
  delete(criteria) {
    if(criteria.pk) {
      q = 'pk=%s'.replace('%s',criteria.pk);
    }
    if (criteria.sk) {
      if (q.length===0) {
        q = 'sk=%s'.replace('%s',criteria.sk);
      } else {
        q += ' & sk=%s'.replace('%s',criteria.tk);
      }
    }
    if (criteria.tk) {
      q += ' & tk=%s'.replace('%s',criteria.tk);
    }
    if (q.length === 0) {
      throw new Error("Missing keys pk, sk and tk");
    }
    qst = 'table[%s]'.replace('%s',q);

    let result = jsonQuery(qst, {
      data: this.table
    });
    console.log('delete result', result);

    result = result.value;

    if (result === null) {
      result = {criteria: criteria, selection: []};
    } else if (result instanceof Array){
      result = {criteria: criteria, selection: result};
    } else {
      result = {criteria: criteria, selection: [result]};
    }
    return result;
  }
}

//export default class { DbClient };
//module.exports = DbClient;
