import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}
import Consts from '../../lib/constants/consts.js';
import DataTypes from '../../lib/constants/data_types.js';

import { ChelateUser } from '../../lib/chelates/chelate_user.js';

describe('ChelateUser New', () => {
  // Initialize
  test('new ChelateUser', () => {
   let form = {
     "username":"abc@xyz.com",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };
    let chelate = {
      pk: "update@user.com",
      sk: "const#USER",
      tk: "guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      form: form
    };
    // New from Form
    expect(new ChelateUser(form)).toBeDefined();
    // New from Chelate
    expect(new ChelateUser(chelate)).toBeDefined();

  })

});
