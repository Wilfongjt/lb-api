import Consts from '../lib/consts.js';
import { ChelateHelper } from '../lib/chelate_helper.js';

describe('ChelateHelper', () => {
  // Initialize
  test('ChelateHelper.resolve() form change ', () => {
    let chelate1 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };
    let chelate2 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"ABC",
         "password":"A1a!AAAA"
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };

    let chelate_resolved = (new ChelateHelper()).resolve(chelate1, chelate2);
    //console.log('chelate_resolved',chelate_resolved);
    expect(typeof(chelate_resolved)).toEqual('object');
    expect(chelate_resolved.pk).toEqual("username#abc@xyz.com");
    expect(chelate_resolved.sk).toEqual("const#USER");
    expect(chelate_resolved.tk).toEqual("guid#520a5bd9-e669-41d4-b917-81212bc184a3");
    expect(chelate_resolved.form.username).toEqual("abc@xyz.com");
    expect(chelate_resolved.form.displayname).toEqual("ABC");
    expect(chelate_resolved.form.password).toEqual("A1a!AAAA");
    expect(chelate_resolved.active).toEqual(true);
    expect(chelate_resolved.created).toEqual("2021-01-23T14:29:34.998Z");

  })

  test('ChelateHelper.resolve() partial form change ', () => {
    let chelate1 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };
    let chelate2 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
         "displayname":"ABC",
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };

    let chelate_resolved = (new ChelateHelper()).resolve(chelate1, chelate2);
    //console.log('pattern',pattern);
    expect(typeof(chelate_resolved)).toEqual('object');
    expect(chelate_resolved.pk).toEqual("username#abc@xyz.com");
    expect(chelate_resolved.sk).toEqual("const#USER");
    expect(chelate_resolved.tk).toEqual("guid#520a5bd9-e669-41d4-b917-81212bc184a3");
    expect(chelate_resolved.form.username).toEqual("abc@xyz.com");
    expect(chelate_resolved.form.displayname).toEqual("ABC");
    expect(chelate_resolved.form.password).toEqual("a1A!aaaa");
    expect(chelate_resolved.active).toEqual(true);
    expect(chelate_resolved.created).toEqual("2021-01-23T14:29:34.998Z");

  })


  test('ChelateHelper.resolve() PK change ', () => {
    let chelate1 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc",
         "password":"a1A!aaaa"
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };
    let chelate2 = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"ABC@XYZ.COM",
         "displayname":"abc",
         "password":"a1A!aaaa"
      },
      "active": true,
      "created": "2021-01-23T14:29:34.998Z"
    };

    let chelate_resolved = (new ChelateHelper()).resolve(chelate1, chelate2);
    //console.log('pattern',pattern);
    expect(typeof(chelate_resolved)).toEqual('object');
    expect(chelate_resolved.pk).toEqual("username#ABC@XYZ.COM");
    expect(chelate_resolved.sk).toEqual("const#USER");
    expect(chelate_resolved.tk).toEqual("guid#520a5bd9-e669-41d4-b917-81212bc184a3");
    expect(chelate_resolved.form.username).toEqual("ABC@XYZ.COM");
    expect(chelate_resolved.form.displayname).toEqual("abc");
    expect(chelate_resolved.form.password).toEqual("a1A!aaaa");
    expect(chelate_resolved.active).toEqual(true);
    expect(chelate_resolved.created).toEqual("2021-01-23T14:29:34.998Z");

  })

});
