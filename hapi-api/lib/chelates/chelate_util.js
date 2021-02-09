import DataTypes from '../lib/data_types.js';
import { v4 as uuidv4 } from 'uuid';
import { Password } from '../lib/password.js';
import { ChelatePattern } from '../lib/chelate_pattern.js';

export class ChelateUtil {
  constructor() {

  }
  static clone(chelate) {
    return JSON.parse(JSON.stringify(chelate));
  }
  static updateFromForm(chelate) {
    // move form elements to keys
    // add or change updated
    // clone chelate
    // get ChelatePattern for constants and identifers
    //

    let pattern = new ChelatePattern(chelate);
    let rc = this.clone(chelate);
    console.log('ChelatePattern', pattern);
    for (let k of pattern) {
      //console.log('k', k[0], k[1]);
      if (k[1].att) {
        //console.log('trans', k[1].att, ' to ', k[0]);
        console.log(k[0], '=',rc['form'][k[1].att]);
        rc[k[0]]=rc['form'][k[1].att];
      }
    }

    return rc;
  }
}
