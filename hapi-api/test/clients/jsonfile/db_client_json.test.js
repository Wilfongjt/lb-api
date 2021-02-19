import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../../.env') });
}
import Const from '../../../lib/constants/consts.js';
import DataTypes from '../../../lib/constants/data_types.js';

import { ChelateUser } from '../../../lib/chelates/chelate_user.js';

import { DbClientSwap } from '../../../lib/clients/db_swap.js';




describe('New DbClientSwap', () => {
  // Initialize
  const config = {
    user: process.env.PGUSER || 'postgres',
    host: 'localhost'|| process.env.PGHOST || 'db',
    database: process.env.PGDATABASE || 'one_db',
    password: process.env.PGPASSWORD || 'mysecretdatabasepassword',
    port: process.env.PGPORT || 5433,
    Client: DbClientSwap
  };

  test('new DbClientSwap', () => {
    expect(new DbClientSwap(config)).toBeDefined();
  })

  test('new DbClientSwap.connect()', () => {
    let client = new DbClientSwap(config);

    expect(client.connect()).toBeDefined();
    client.end();
  })

  test('.query All,  DbClientSwap.query(\'*\')', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let queryResult = await client.query('*');

    expect(queryResult.selection.length).not.toEqual(0);

  })
  //

  test('.query existing element', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let queryResult = await client.query({pk:"username#existing@user.com",sk:"const#USER"});

    expect(queryResult.selection.length).toEqual(1);

    for (let i in queryResult.selection) {
      let item = queryResult.selection[i];

      expect(item.pk).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.sk).toEqual(DataTypes.userType());
      expect(item.tk).toMatch(new RegExp(Const.guidPlusPattern(),'i'));
      expect(item.form).toBeDefined();
      expect(item.form.username).toMatch(new RegExp(Const.emailPattern(),'i'));
      expect(item.form.displayname).toEqual('J');
      expect(item.form.password).toBeDefined();

      expect(item.created).toBeDefined();
      expect(item.updated).not.toBeDefined();

    }
  })

  test('.query list of elements by const', async () => {
    let client = new DbClientSwap(config);
    await client.connect();

    let queryResult = await client.query({sk:"const#USER"});

    expect(queryResult.selection.length).not.toEqual(0);
    for (let i in queryResult.selection) {
      let item = queryResult.selection[i];

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

  test('.select non-existant element', async () => {
    let client = new DbClientSwap(config);
    client.connect();

    let result = await client.query({pk:"username#non-existing-user",sk:"const#USER"});
    //console.log('result', result);
    expect(result).toMatchObject({criteria:{pk:"username#non-existing-user",sk:"const#USER"}, selection:[]});
  })

  // Insert
  test('.insert USER', async () => {
    let client = new DbClientSwap(config);
    await client.connect();

    let form = {
      "username":"abc@xyz.com",
       "displayname":"abc",
       "password":"a1A!aaaa"
     };
     ///console.log('Insert USER form', form);
    let insertResult = await client.insert(new ChelateUser(form));
    //console.log('insertResult', insertResult);
    //let insertAliasResult = client.insert(new UserAliasChelate(insertResult));

    //expect(insertResult.isValid).toEqual(true);
    expect(insertResult.insertion).toBeDefined();
    expect(insertResult.insertion.pk).toMatch(new RegExp(Const.emailPattern(),'i'));
    expect(insertResult.insertion.sk).toEqual(DataTypes.userType());
    expect(insertResult.insertion.tk).toMatch(new RegExp(Const.guidPlusPattern(),'i'));
    expect(insertResult.insertion.form).toBeDefined();
    expect(insertResult.insertion.form.username).toMatch(new RegExp(Const.emailPattern(),'i'));
    expect(insertResult.insertion.form.displayname).toEqual('abc');
    expect(insertResult.insertion.form.password).toBeDefined();

    expect(insertResult.insertion.created).toBeDefined();
    expect(insertResult.insertion.updated).toBeDefined();
  })

  test('.insert USER duplicate', async () => {
    let client = new DbClientSwap(config);
    await client.connect();

    let form = {
      "username":"existing@user.com",
       "displayname":"J",
       "password":"a1A!aaaa"
     };

    // isert first
    // attemp duplicate
    //console.log('test insert dup',new ChelateUser(form));
    let insertResult = await client.insert(new ChelateUser(form));
    expect(insertResult.insertion).toEqual(false);
    expect(insertResult.error).toEqual('Duplicate not allowed!');
  })

  // Delete
  test('.delete existing USER', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    //let expected_size = client.table.table.length - 1;
    let deleteResult = await client.delete({pk:"username#delete@user.com",sk:"const#USER"});
    // table should be one less
    //expect(client.table.table.length).toEqual(expected_size);

    for (let i in deleteResult.deletion) {
      let item = deleteResult.deletion[i];
      expect(item.pk).toEqual("username#delete@user.com");
      expect(item.sk).toEqual("const#USER");
      expect(item.tk).toEqual("guid#720a5bd9-e669-41d4-b917-81212bc184a3");
    }
    //console.log('table', client.table);
  })

  test('.delete non-existing USER', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    //let expected_size = client.table.table.length;
    let deleteResult = await client.delete({pk:"usename#nonexisting@user.com",sk:"const#USER"});
    //console.log('deleteResult',deleteResult);
    // table should be the same size
    //expect(client.table.table.length).toEqual(expected_size);
    expect(deleteResult).toBeDefined();
    expect(deleteResult.deletion).toEqual([]);

  })

  // Update USER password

  test('.update form only no key changes', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let form = {
      "username":"update@user.com",
      "displayname":"J",
      "password": "b1A!bbbb"
     };

    let updated_chelate = {
      "pk": "username#update@user.com",
      "sk": "const#USER",
      "tk": "guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": form,
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };

    //let clt = new ChelateUser(chelate);//.update(form);
    //console.log('updated_chelate',updated_chelate);

    let updateResults = await client.update(updated_chelate);
    //console.log('test updateResults',updateResults);
    //console.log('test updateResults', JSON.parse(JSON.stringify(updateResults.updates[0].form)));
    expect(updateResults.criteria).toEqual({"pk": "username#update@user.com", "sk": "const#USER"});
    expect(updateResults.updates[0].form.password).not.toBeDefined();
  })
  test('.update PK change', async () => {
    let client = new DbClientSwap(config);
    await client.connect();

    let updated_chelate = {
      "pk": "username#update@user.com",
      "sk": "const#USER",
      "tk": "guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      "form": {
        "username":"UPDATE@USER.COM",
        "displayname":"J",
        "password": "a1A!aaaa"
       },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };

    //let clt = new ChelateUser(chelate);//.update(form);
    //console.log('updated_chelate',updated_chelate);

    let updateResults = await client.update(updated_chelate);
    //console.log('test updateResults',updateResults);
    //console.log('test updateResults', JSON.parse(JSON.stringify(updateResults.updates[0].form)));
    expect(updateResults.criteria).toEqual({"pk": "username#update@user.com", "sk": "const#USER"});
    expect(updateResults.updates[0].pk).toEqual("username#update@user.com");
    expect(updateResults.updates[0].form.password).not.toBeDefined();

    let rec =  client.table.table[4]; // deleted record
    expect(rec.pk).not.toEqual("username#update@user.com");
    rec =  client.table.table[client.table.table.length - 1]; // appended record with update
    expect(rec.pk).toEqual("username#UPDATE@USER.COM");
    expect(rec.form.password).toBeDefined();

  })

  test('.signin( username, password)', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let credentials = {'username': 'existing@user.com', 'password':'a1A!aaaa'};
    let signin = await client.signin(credentials);

    expect(signin).toBeDefined();
    expect(signin.credentials).toBeDefined();
    expect(signin.credentials.username).toBeDefined();
    expect(signin.credentials.password).not.toBeDefined();
    expect(signin.authentication).toBeDefined();
    //expect(signin.authentication.token.replace('Bearer ', '')).toMatch(Const.tokenPattern());
    expect(signin.authentication.token).toBeTruthy();

  })

  test('.signin( username, BADpassword) Password Failure', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let credentials = {'username': 'existing@user.com', 'password':'xxxxxxxx'};
    let signin = await client.signin(credentials);

    //console.log('test','signin',signin);
    expect(signin).toBeDefined();
    expect(signin.credentials).toBeDefined();
    expect(signin.credentials.password).not.toBeDefined();

    expect(signin.authentication).toBeFalsy();
    expect(signin.authentication.token).toBeFalsy();
  })

  test('.signin( BADusername, password) Username Failure', async () => {
    let client = new DbClientSwap(config);
    await client.connect();
    let credentials = {'username': 'bad@user.com', 'password':'a1A!aaaa'};
    let signin = await client.signin(credentials);

    //console.log('test','signin',signin);
    expect(signin).toBeDefined();
    expect(signin.credentials).toBeDefined();
    expect(signin.credentials.password).not.toBeDefined();

    expect(signin.authentication).toBeFalsy();
    expect(signin.authentication.token).toBeFalsy();
  })

});
