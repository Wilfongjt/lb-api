
import DbClientConfig from './db_client_config.js';
import Chelate from './chelate.js'
//const jsonQuery = require('json-query');
import jsonQuery from 'json-query';
import DataTypes from '../lib/data_types.js';

export default class DbClient {
  constructor () {
    //console.log('db client ');
    this.table = {};
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
    }
    return this;
  }


  select() {return this.table}
  /*
  insert(form) {
    // Goal: Add item to table
    // Strategy: chelate stratagy,
    //           grab the item with a claw/chela and put it in a table

    // check pk, sk, data for duplicate

    return form;
  }
  */
  insert(chelate) {

      //try {
        let item = chelate.toJson();
        if (!item.pk) {
          throw new Error('Missing pk value');
        }
        if (!item.sk) {
          throw new Error('Missing sk value');
        }
        if (!item.data) {
          throw new Error('Missing data value');
        }

        if (!this.table) {
          throw new Error('Not connected to data');
        }
        // look for duplicate
        let qst = 'table[pk=%s & sk=%s]'.replace('%s',item.pk).replace('%s',item.sk);

        let result = jsonQuery(qst, {
          data: this.table
        });

        if (result.value){
          //throw new Error('Duplicate');
          return {isValid: false, result: 'Duplicate'};
        }

        this.table.table.push(item);
        // insertResponse
        return {isValid: true, result: item};
  }
/*
  insertAlias(insertResponse) {
    if (! insertResponse) {
      throw new Error('Undefined insertResponse');
    }
    if (! insertResponse.isValid){
      throw new Error('Failed insertResponse');
    }

    if (!insertResponse.result) {
      throw new Error('Undefined insertResponse.result');
    }

    if (! DataTypes.in(insertResponse.result.data)) {
      throw new Error('Unknown DataType %s'.replace('%s',insertRespons.result.data));
    }

    let alias = JSON.stringify(insertResponse.result);
    //console.log('alias', alias);
    let aliasForm = {}
    return {isValid: true, result: ""};
  }
*/
  //update(form) {return form;}
  update(chelate) {
    let item = chelate.toJson();
    let _datetime = new Date();
    // update wrapper changed attributes
    // skip missing wrapper attributes
    // update form attributes
    // add new attributes
    if (!item.pk) {
      throw new Error('Missing pk value');
    }
    if (!item.sk) {
      throw new Error('Missing sk value');
    }
    if (!item.data) {
      throw new Error('Missing data value');
    }
    if (!this.table) {
      throw new Error('Not connected to data');
    }

    // look for duplicate
    let qst = 'table[pk=%s & sk=%s]'
                .replace('%s',item.pk)
                .replace('%s',item.sk);

    let result = jsonQuery(qst, {
      data: this.table
    });
//console.log('result',result);
    if (! result.value) {
      throw new Error('Update %s %s not found'.replace('%s',item.pk).replace('%s',item.sk));
    }
    
    let found_key = result.key;
    let changed = false;

//console.log('found_key', found_key);

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
    //console.log('return',this.table.table[found_key]);
    if (changed) {
       this.table.table.[found_key]['updated'] = _datetime;
    }
    return {isValid: true, result: JSON.parse(JSON.stringify(this.table.table[found_key]))};
  };

  delete(form) {return form;}
}

//export default class { DbClient };
//module.exports = DbClient;
