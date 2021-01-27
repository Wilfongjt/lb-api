import DataTypes from '../lib/data_types.js';
import { v4 as uuidv4 } from 'uuid';

export class Chelate extends Map {
  constructor () {
    super();
    let _datetime = new Date();
    this.set("pk","");
    this.set("sk","");
    this.set("tk","");
    this.set("form",{});
    this.set("active", true);
    this.set("created",_datetime);
    // this.set("updated",_datetime);
  }
  validate(form) {

    return true;
  }

  toJson() {
    return Object.fromEntries(this); ;
  }

  //update( form ) {
//    this.form = form;
  //}

}
/*
"form": {
  "id": "woden@citizenlabs.org",
  "app": "Adopt-A-Drain",
  "key": "15f9dd5c-4451-4eb7-8146-0b9518990500",
  "org": "CitizenLabs",
  "name": "woden@citizenlabs.org",
  "type": "woden",
  "roles": "woden,admin",
  "password": "$2a$06$SbZ4FeMPXpiSkQKARwMyp.TsjTFgRBaaNrWphWzIzRY819aLzc0w."
}
*/

/*
{ // response wrapper
  isValid: true,
  result: { // chelate wrapper
    pk:"",
    sk:"",
    data:"",
    form: {

    },
    created:"",
    updated:""
  }
}
*/
/*

*/
export class UserChelate extends Chelate {
  constructor (form) {
    super();
    ///this.set('dups', false);

    if( form.isValid ) { // from response from insert or update
      // get result.form
      this.set('pk',form.result.pk);
      this.set('sk',form.result.sk);
      this.set('tk',form.result.tk);
      this.set('form',JSON.parse(JSON.stringify(form.result.form)));
      this.set('created', form.result.created);
      if (form.result.updated) {
        this.set('updated', form.result.updated);
      }
    } else if ( form.pk ) { // wrap

      this.set('pk',form.pk);
      this.set('sk',form.sk);
      this.set('tk',form.tk);
      this.set('form',JSON.parse(JSON.stringify(form.form)));
      this.set('created', form.created);
      if (form.updated) {
        this.set('updated', form.updated);
      }

    } else if ( form.username ) { // straight user-form

      this.set("pk", form.username);
      this.set("sk", DataTypes.userType());
      this.set("tk", uuidv4());

      this.set("form", JSON.parse(JSON.stringify(form)));
    }
  }

  setForm(form){
    this.set('form', form);
    return this;
  }
}
/*
export class UserChelate extends Chelate {
  constructor (form) {
    super();

    if( form.isValid ) { // from response from insert or update
      // get result.form
      this.set('pk',form.result.pk);
      this.set('sk',form.result.sk);
      this.set('data',form.result.data);
      this.set('form',JSON.parse(JSON.stringify(form.result.form)));
      this.set('created', form.result.created);
      if (form.result.updated) {
        this.set('updated', form.result.updated);
      }
    } else if ( form.pk ) { // wrap
      this.set('pk',form.pk);
      this.set('sk',form.sk);
      this.set('data',form.data);
      this.set('form',JSON.parse(JSON.stringify(form.form)));
      this.set('created', form.created);
      if (form.updated) {
        this.set('updated', form.updated);
      }

    } else if ( form.username ) { // straight user-form

      this.set("pk", uuidv4());
      this.set("sk", DataTypes.userType());
      //this.set("sk", "profile#%s".replace('%s',item.username));
      this.set("data", DataTypes.userType());
      this.set("form", JSON.parse(JSON.stringify(form)));
    }
  }

  setForm(form){
    this.set('form', form);
    return this;
  }
}

export class UserAliasChelate extends Chelate {
  constructor (item) {
    super();
    // from response from insert or update
    //if( item.isValid ){ // from response from insert or update
      // get result.form
      this.set('pk',item.result.form.username);
      this.set('sk', DataTypes.aliasType());
      this.set('data',DataTypes.userType());
      this.set('form',{pk:item.result.form.pk, sk:item.result.form.sk});
      this.set('created', item.result.created);
      if (item.result.updated) {
        this.set('updated', item.result.updated);
      }
      */
    /*} else if ( item.pk ){ // user-chelate
      // get
      this.set('pk',item.pk);
      this.set('sk',item.sk);
      this.set('data',item.data);
      this.set('form',JSON.parse(JSON.stringify(item.form)));
      this.set('created', item.created);
      if (item.updated) {
        this.set('updated', item.updated);
      }
    }*/
    /*
  }
}
*/
