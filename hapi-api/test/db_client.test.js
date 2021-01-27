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

  test('Select All', () => {
    let client = new DbClient().connect();
    let selectResult = client.select('*');

    //let selectResult = client.select({pk:"520a5bd9-e669-41d4-b917-81212bc184a3",sk:"USER"});
    //console.log('selectResult', selectResult);
    expect(selectResult.selection.length).not.toEqual(0);

  })
  //

  test('Select existing USER', () => {
    let client = new DbClient().connect();
    let selectResult = client.select({pk:"existing@user.com",sk:"USER"});

    //let selectResult = client.select({pk:"520a5bd9-e669-41d4-b917-81212bc184a3",sk:"USER"});
    //console.log('selectResult', selectResult);
    expect(selectResult.selection.length).toEqual(1);

    for (let i in selectResult.selection) {
      let item = selectResult.selection[i];
      //console.log('selectResult.selection',selectResult.selection);
      //console.log('item', item);

      expect(item.pk).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.sk).toEqual(DataTypes.userType());
      expect(item.tk).toMatch(new RegExp(Const.guidPattern(),'i'));
      expect(item.form).toBeDefined();
      expect(item.form.username).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.form.displayname).toEqual('J');
      expect(item.form.password).toBeDefined();

      expect(item.created).toBeDefined();
      expect(item.updated).not.toBeDefined();

    }
  })


  test('Select list of USER', () => {
    let client = new DbClient().connect();

    let selectResult = client.select({sk:"USER"});
    //console.log('selectResult', selectResult);
    //expect(selectResult.isValid).toEqual(true);
    //expect(selectResult.result).toBeDefined();
    expect(selectResult.selection.length).not.toEqual(0);
    for (let i in selectResult.selection) {
      let item = selectResult.selection[i];

      expect(item.pk).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.sk).toEqual(DataTypes.userType());
      //expect(item.tk).toMatch(new RegExp(Const.guidPattern(),'i'));
      expect(item.form).toBeDefined();
      expect(item.form.username).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.form.displayname).toEqual('J');
      expect(item.form.password).toBeDefined();

      expect(item.created).toBeDefined();
      expect(item.updated).not.toBeDefined();
    }
  })

  test('Select non existant USER', () => {
    let client = new DbClient().connect();

    let result = client.select({pk:"non-existing-user",sk:"USER"});
    //console.log('result', result);
    expect(result).toMatchObject({criteria:{pk:"non-existing-user",sk:"USER"}, selection:[]});
  })

  test('Select and direct change a selection', () => {
    // run query
    // update the results
    let client = new DbClient().connect();

    let result = client.select({pk:"selectchange@user.com",sk:"USER"});
    //console.log('A selectchange result', result);
    result.selection[0].active=false;
    result = client.select({pk:"selectchange@user.com",sk:"USER"});
    //console.log('B selectchange result', result);
    expect(result.selection[0].active).toEqual(false);
    //console.log('client.table.table', client.table.table);
    //expect(result).toMatchObject({criteria:{pk:"selectchange@user.com",sk:"USER"}, selection:[]});
  })

  test('Select and mergeHot change a selection', () => {
    // run query
    // update the results
    let client = new DbClient().connect();

    let result = client.select({pk:"selectchange@user.com",sk:"USER"});
    let changes = {active: false};
    result = client.select({pk:"selectchange@user.com",sk:"USER"});
    client.mergeHot(changes, result.selection[0]);
    expect(result.selection[0].active).toEqual(false);
  })
  test('Select and mergeCopy change a selection', () => {
    // run query
    // update the results
    let client = new DbClient().connect();

    let result = client.select({pk:"selectchange@user.com",sk:"USER"});
    let changes = {active: false};
    result = client.select({pk:"selectchange@user.com",sk:"USER"});
    client.mergeCopy(changes, result.selection[0]);
    expect(result.selection[0].active).toEqual(true);
  })
  // Insert
  test('Insert USER', () => {
    let client = new DbClient().connect();

    let form = {
      "username":"abc@xyz.com",
       "displayname":"abc",
       "password":"a1A!aaaa"
     };

    let insertResult = client.insert(new UserChelate(form));
    //console.log('userchelate', new UserChelate(form));
    //let insertAliasResult = client.insert(new UserAliasChelate(insertResult));

    expect(insertResult.isValid).toEqual(true);
    expect(insertResult.result).toBeDefined();
    expect(insertResult.result.pk).toMatch(new RegExp(Const.emailPattern(),'i'));
    expect(insertResult.result.sk).toEqual(DataTypes.userType());
    expect(insertResult.result.tk).toMatch(new RegExp(Const.guidPattern(),'i'));
    expect(insertResult.result.form).toBeDefined();
    expect(insertResult.result.form.username).toMatch(new RegExp(Const.emailPattern(),'i'));
    expect(insertResult.result.form.displayname).toEqual('abc');
    expect(insertResult.result.form.password).toBeDefined();

    expect(insertResult.result.created).toBeDefined();
    expect(insertResult.result.updated).not.toBeDefined();
  })

  test('Insert USER duplicate', () => {
    let client = new DbClient().connect();

    let form = {
      "username":"existing@user.com",
       "displayname":"J",
       "password":"a1A!aaaa"
     };

    // isert first
    //let insertResult1 = client.insert(new UserChelate(form));
    // attemp du0licat//e
    let insertResult = client.insert(new UserChelate(form));
    expect(insertResult.isValid).toEqual(false);
    expect(insertResult.error).toEqual('Duplicate not allowed!');
  })

  // Delete
  test('Delete existing USER', () => {
    let client = new DbClient().connect();
    let expected_size = client.table.table.length - 1;
    let deleteResult = client.delete({pk:"delete@user.com",sk:"USER"});
    // table should be one less
    expect(client.table.table.length).toEqual(expected_size);
    //
    //console.log('deleteResult',deleteResult);
    //console.log('pk', deleteResult.deletion);
    for (let i in deleteResult.deletion) {
      let item = deleteResult.deletion[i];
      expect(item.pk).toEqual("delete@user.com");
      expect(item.sk).toEqual("USER");
      expect(item.tk).toEqual("720a5bd9-e669-41d4-b917-81212bc184a3");
    }
    //console.log('table', client.table);
  })
  test('Delete non-existing USER', () => {
    let client = new DbClient().connect();
    let expected_size = client.table.table.length;
    let deleteResult = client.delete({pk:"nonexisting@user.com",sk:"USER"});
    // table should be the same size
    expect(client.table.table.length).toEqual(expected_size);

  })

  // Update USER password

  test('Form Password Update USER', () => {
    let client = new DbClient().connect();

    let form = {
       "password": "b1A!bbbb"
     };
    let chelate = {
      sk: "USER",
      tk: "820a5bd9-e669-41d4-b917-81212bc184a3",
      form: form
    };

    // update
    let updateResult = client.update(chelate);

    //console.log('updateResult',updateResult);
    let criteria = { sk: 'USER', tk: '820a5bd9-e669-41d4-b917-81212bc184a3' };
    let selection = client.select(criteria);

    expect(selection.selection[0].form.password).toEqual("b1A!bbbb");

  })


});
