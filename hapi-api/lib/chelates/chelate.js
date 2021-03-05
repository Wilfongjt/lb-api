import { v4 as uuidv4 } from 'uuid';

export class Chelate {
  constructor(key_map, form) {
    /*
    key_map ex
    {
      pk:{att: "username"},
      sk:{const: "USER"},
      tk:{guid: "*"}        // * is flag to calculate guid when not provided
    }
    */
    //this.#keys=key_map;
    if(form && key_map) {
      // create new when a form is provided
      //console.log('this._guessFormType(key_map,form)',this._guessFormType(key_map,form));
      switch(this._guessFormType(key_map,form)){
        case 1: // form
            this._assignForm(key_map,form);
          break;
        case 2: // chelate + form
            this._assignChelate(key_map,form);
          break;
      }
    } else {
      if(key_map && !form ){
        throw new Error(`Chelate is missing keymap or form`);
      }
    }
  }

  _guessFormType(key_map, obj) {
    //console.log('key_map', key_map);
    if(!key_map){
      return 0; // unhandled
    }
    if(!obj){
      return 0; // unhandled
    }
    if (obj['pk'] && obj['sk'] && obj['tk'] && obj['form']) {
      return 2; // chelate with form
    } else if(!obj['pk'] && !obj['sk'] && !obj['tk'] && !obj['form']) {
      return 1;// form
    }
    return 0; // unhandled
  }

  _assignForm(key_map, form){
    for (let k in key_map) { //  k is integer
      let isKeyName = key_map[k]['att'];
      if (key_map[k]['att']) {
        let isKeyNameInForm =  form[key_map[k]['att']];
        if (! isKeyNameInForm) { //
          throw new Error(`Chealate form must contain ${key_map[k]['att']} ${form[key_map[k]['att']]}`);
        }
        // <form-attribute-name>#<value>  eg username#john@gmail.com
        let form_name = key_map[k]['att'];
        let form_val = form[key_map[k]['att']];
        this[k] =  `${form_name}#${form_val}` ;
      } else if (key_map[k]['const']) { // eg USER
        let const_val = key_map[k]['const'];
        this[k] = `const#${const_val}`;
        //this[k] = 'const#' + key_map[k]['const'];
      } else if (key_map[k]['guid']) { // eg 820a5bd9-e669-41d4-b917-81212bc184a3
        let guid_value = key_map[k]['guid'] ;
        this[k] = `guid#${guid_value}`;
        //this[k] = 'guid#' + key_map[k]['guid'];
        if(this[k] === 'guid#*'){ // calculate the guid
          this[k] =  'guid#' + uuidv4();
        }
      }
    }
    // chelate has to have all keys in key_map
    this['form'] =JSON.parse(JSON.stringify(form));
    
    this['active'] = true;

    let dat = new Date();
    this['created'] = dat;
    // updated is changed in the update process
    this['updated'] = dat;

    return this;
  }
  _assignChelate(key_map, chelate) {
    for (let k in chelate) {
      this[k]= chelate[k];
    }
    for (let k in key_map) {
      if(! this[k]){
        throw new Error(`Missing ${k} key.`);
      }
    }
    if (!this['active']){
      this['active'] = true;
    }
    let dat = new Date();
    if (!this['created']) {
      this['created'] = dat;
    }
    // updated is changed in the update process
    if (!this['updated']) {
      this['updated'] = dat;
    }
    return this;
  }

  toJson() {
    //console.log('toJson',this);
    //return JSON.parse(this.toString());
    let rc = {}

    for (let k in this) {
      rc[k] =  this[k];
    }

    return rc;
  }
/*
  assign(chelate) {

    for (let k in chelate) {
      this[k]= chelate[k];
    }

    return this;
  }
*/
  getKeyMap() {
      let pattern = new Pattern(this);
      return pattern.getKeyMap();
  }
/*
  update(form) {
    if ( this.form ){
      for (let k in form) {
        this.form[k]=form[k];
      }
    }
    return this;
  }
*/
}
