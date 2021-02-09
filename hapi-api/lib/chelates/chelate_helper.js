import { ChelatePattern } from './chelate_pattern.js';
import { Chelate } from './chelate.js';

export class ChelateHelper {
  constructor() {}
  resolve(chelate_to, chelate_from) {
    // get third object that is combo of _to and _from
    // get pattern of object
    // chelate_to has to have complete key set and form set
    // chelate_from must have the same key set as chelate_to
    // chelate_from may have more or fewer form name:value pairs

    let new_key_pattern = new ChelatePattern(chelate_from);
    let new_form = JSON.parse(JSON.stringify(chelate_to.form)) ;//+ chelate_from.form;
    for (let k in chelate_from.form) { // merge from.form into new.form
      new_form[k]=chelate_from.form[k];
    }

    let final_chelate = new Chelate(new_key_pattern.getKeyMap(), new_form);
    final_chelate.active = chelate_to.active;
    final_chelate.created = chelate_to.created;
    if ( chelate_to.updated) {
      final_chelate.updated = chelate_to.updated; // this is update time before this update
    }

    return final_chelate;
  }
  /*
  resolve(chelate_to, chelate_from) {

    let copy = JSON.parse(JSON.stringify(chelate_to))
    if (copy) {
      for (let k in chelate_from.form) {
        copy.form[k]=chelate_from.form[k];
      }
    }
    return copy;
  }

  */

}
