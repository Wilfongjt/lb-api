import { v4 as uuidv4 } from 'uuid';
import { Chelate } from './chelate.js';

import DataTypes from '../../lib/constants/data_types.js';
import { Password } from '../../lib/auth/password.js';

export class ChelateUser extends Chelate {
  constructor (form) {
    super({
      pk:{att: "username"},
      sk:{const: "USER"},
      tk:{guid: "*"}        // * is flag to calculate guid when not provided
    },form);
    /*
    let password = new Password();
    this.form.password = password.hashify(this.form.password);
    */
  }

};
