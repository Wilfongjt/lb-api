import DataTypes from '../lib/data_types.js';
import { v4 as uuidv4 } from 'uuid';
import { Password } from '../lib/password.js';
import { Chelate } from '../lib/chelate.js';

export class ChelateUser extends Chelate {
  constructor (form) {
    super({
      pk:{att: "username"},
      sk:{const: "USER"},
      tk:{guid: "*"}        // * is flag to calculate guid when not provided
    },form);
    let password = new Password();
    this.form.password = password.hashify(this.form.password);
  }

};
