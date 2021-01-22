import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
import Const from '../lib/consts.js';

import DbClient from '../lib/db_client.js';
import { UserChelate } from '../lib/chelate.js';
import { UserAliasChelate } from '../lib/chelate.js';

import DataTypes from '../lib/data_types.js';

describe('DbClient', () => {
  // Initialize
  test('new DbClient', () => {
    //const config = new DbClientConfig();
    expect(new DbClient()).toBeDefined();
  })

  test('new DbClient.connect()', () => {
    let client = new DbClient();
    expect(client.connect()).toBeDefined();
    expect(client.table).toBeDefined();
  })

  // Insert
  test('Insert USER', () => {
    let client = new DbClient().connect();

    let form = {
      "username":"abc xyz",
       "displayname":"abc",
       "password":"a1A!aaaa"
     };

    //let chelate = new UserChelate(form);
    let insertResult = client.insert(new UserChelate(form));
    let insertAliasResult = client.insert(new UserAliasChelate(insertResult));

    expect(insertResult.isValid).toEqual(true);
    expect(insertResult.result).toBeDefined();
    expect(insertResult.result.pk).toMatch(new RegExp(Const.guidPattern(),'i'));
    expect(insertResult.result.sk).toEqual(DataTypes.userType());
    expect(insertResult.result.data).toEqual(DataTypes.userType());
    expect(insertResult.result.form).toBeDefined();
    expect(insertResult.result.form.username).toEqual('abc xyz');
    expect(insertResult.result.form.displayname).toEqual('abc');
    expect(insertResult.result.form.password).toBeDefined();

    expect(insertResult.result.created).toBeDefined();
    expect(insertResult.result.updated).not.toBeDefined();
  })

  test('Insert USER duplicate', () => {
    let client = new DbClient().connect();

    //expect(client.connect()).toBeDefined();
    //expect(client.table).toBeDefined();
    let form = {
      "username":"abc xyz",
       "displayname":"abc",
       "password":"a1A!aaaa"
     };

    // isert first
    let insertResult1 = client.insert(new UserChelate(form));
    //console.log('A client.table', client.table);
    // attemp du0licat//e
    let insertResult = client.insert(new UserChelate(insertResult1));
    //console.log('B client.table', client.table);

    expect(insertResult.isValid).toEqual(false);

    expect(insertResult.result).toEqual('Duplicate');
  })

  // Update USER password

  test('Update USER', () => {
    let client = new DbClient().connect();

    let form1 = {
      "username":"abc xyz",
       "displayname":"abc",
       "password":"a1A!aaaa"
     };

    // first: insert
    let insertResult = client.insert(new UserChelate(form1));
    //console.log('insertResult A',insertResult)
    // second: insert
    //let chelate = new UserChelate(insertResult);

    // attemp du0licate
    let form2 = {
       "password":"a1A!aaaa2"
     };
    let chelate = new UserChelate(insertResult).setForm(form2);

    // swap out the old form with new
    // chelate.set('form', form2)

    //console.log('chelate B', chelate);
    // update
    let updateResult = client.update(chelate);
    // console.log('updateResult', updateResult);
    //console.log('updated', updateResult);

    expect(updateResult.isValid).toEqual(true);

    expect(updateResult.result).toBeDefined();
    //expect(updateResult.result.pk).toMatch(/^[0-9A-F]{8}-[0-9A-F]{4}-[5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i);
    // var pattern = new RegExp('^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$', 'i');

    expect(updateResult.result.pk).toMatch(new RegExp(Const.guidPattern(),'i'));


    //expect(updateResult.result.pk).toMatch(new RegExp(/^[0-9A-F]{8}-[0-9A-F]{4}-[5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i));
    expect(updateResult.result.sk).toEqual(DataTypes.userType());
    //expect(updateResult.result.pk).toEqual('abc xyz');
    //expect(updateResult.result.sk).toEqual('profile#abc xyz');
    expect(updateResult.result.data).toEqual(DataTypes.userType());
    expect(updateResult.result.form).toBeDefined();
    expect(updateResult.result.created).toBeDefined();
    expect(updateResult.result.updated).toBeDefined();

  })
  //

  // Delete

});
