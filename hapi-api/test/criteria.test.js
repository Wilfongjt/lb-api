import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
import Consts from '../lib/consts.js';

import { Criteria } from '../lib/criteria.js';
import { CriteriaPK } from '../lib/criteria.js';
import { CriteriaSK } from '../lib/criteria.js';
import { CriteriaBest } from '../lib/criteria.js';

import DataTypes from '../lib/data_types.js';
//import Utils from '../lib/utils.js';

describe('Criteria', () => {
  // Initialize
  test('Criteria', () => {
    let chelate = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      }
    };

    let criteria = new Criteria(chelate);
    //console.log('*** Criteria', criteria);
    expect(criteria).toBeDefined();
    expect(criteria.pk).toBeTruthy();
    expect(criteria.sk).toBeTruthy();
    expect(criteria.tk).toBeTruthy();

  })
  test('CriteriaPk', () => {
    let chelate = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      }
    };

    let criteria = new CriteriaPK(chelate);
    //console.log('*** CriteriaPK', criteria);
    expect(criteria).toBeDefined();
    expect(criteria.pk).toBeTruthy();
    expect(criteria.sk).toBeTruthy();
    expect(criteria.tk).toBeFalsy();

  })

  test('CriteriaSK', () => {
    let chelate = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      }
    };

    let criteria = new CriteriaSK(chelate);
    //console.log('*** CriteriaSK', criteria);
    expect(criteria).toBeDefined();
    expect(criteria.pk).toBeFalsy();
    expect(criteria.sk).toBeTruthy();
    expect(criteria.tk).toBeTruthy();

  })


    test('CriteriaBest PK SK', () => {
      let chelate = {
        pk: "username#abc@xyz.com",
        sk: "const#USER",
        tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
        form: {
          "username":"abc@xyz.com",
           "displayname":"abc",
           "password":"a1A!aaaa"
        }
      };

      let criteria = new CriteriaBest(chelate);
      //console.log('*** CriteriaBest', criteria);
      expect(criteria).toBeDefined();
      expect(criteria.pk).toBeTruthy();
      expect(criteria.sk).toBeTruthy();
      expect(criteria.tk).toBeFalsy();

    })
    test('CriteriaBest PK SK', () => {
      let chelate = {
        sk: "const#USER",
        tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
        form: {
          "username":"abc@xyz.com",
           "displayname":"abc",
           "password":"a1A!aaaa"
        }
      };

      let criteria = new CriteriaBest(chelate);
      //console.log('*** CriteriaBest', criteria);
      expect(criteria).toBeDefined();
      expect(criteria.pk).toBeFalsy();
      expect(criteria.sk).toBeTruthy();
      expect(criteria.tk).toBeTruthy();

    })
});
