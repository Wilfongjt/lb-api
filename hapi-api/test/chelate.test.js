import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
import Consts from '../lib/consts.js';

import { UserChelate } from '../lib/chelate.js';
import DataTypes from '../lib/data_types.js';
//import Utils from '../lib/utils.js';

describe('Chelate', () => {
  // Initialize
  test('new UserChelate', () => {
   let form = {
     "username":"abc xyz",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };
    expect(new UserChelate(form)).toBeDefined();

  })

  test('toJson UserChelate', () => {
   //let dataTypes = new DataTypes();
   let form = {
     "username":"abc xyz",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };

    let chelate = new UserChelate(form)

    expect(chelate.toJson()).toBeDefined();

  })

  test('Form to UserChelate', () => {
   //let dataTypes = new DataTypes();
   let form = {
     "username":"abc xyz",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };

    let chelate = new UserChelate(form)

    //expect(chelate.get('pk')).toMatch(/^[0-9A-F]{8}-[0-9A-F]{4}-[5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i);
    expect(chelate.get('pk')).toMatch(new RegExp(Consts.guidPattern(),'i'));

    expect(chelate.get('sk')).toEqual(DataTypes.userType());
    expect(chelate.get('data')).toEqual(DataTypes.userType());
    expect(chelate.get('created')).toBeDefined();
    expect(chelate.get('updated')).not.toBeDefined();
    expect(chelate.get('form')).toBeDefined();
    expect(chelate.get('form')).toMatchObject(form);

  })

  test('value wrapper assignments to UserChelate', () => {

    let wrap = {
       "pk": "421b79c7-38dd-432c-b0a2-17d05c1f9aea",
       "sk": 'USER',
       "data": "USER",
       "form": {
          "username":"abc xyz",
          "displayname":"abc",
          "password":"a1A!aaaa"
       },
       "created": "2020-12-13T16:04:14.094073"
     }
    let chelate = new UserChelate(wrap);

    expect(chelate.get('pk')).toMatch(new RegExp(Consts.guidPattern(),'i'));

    expect(chelate.get('sk')).toEqual(DataTypes.userType());
    expect(chelate.get('data')).toEqual(DataTypes.userType());
    expect(chelate.get('created')).toBeDefined();
    expect(chelate.get('updated')).not.toBeDefined();
    expect(chelate.get('form')).toBeDefined();
    expect(chelate.get('form')).toMatchObject(wrap.form);

  })

  test('value response assignments to UserChelate', () => {
   //let dataTypes = new DataTypes();
   let response = {
    "isValid": true,
    "result": {
       "pk": "421b79c7-38dd-432c-b0a2-17d05c1f9aea",
       "sk": 'USER',
       "data": "USER",
       "form": {
          "username":"abc xyz",
          "displayname":"abc",
          "password":"a1A!aaaa"
       },
       "created": "2020-12-13T16:04:14.094073"
     }
   };

    let chelate = new UserChelate(response);

    expect(chelate.get('form')).not.toEqual({});
    expect(chelate.get('pk')).toMatch(new RegExp(Consts.guidPattern(),'i'));
    expect(chelate.get('sk')).toEqual(DataTypes.userType());
    expect(chelate.get('data')).toEqual(DataTypes.userType());
    expect(chelate.get('created')).toBeDefined();
    expect(chelate.get('updated')).not.toBeDefined();
    expect(chelate.get('form')).toBeDefined();
    expect(chelate.get('form')).toMatchObject(response.result.form);

  })

});
