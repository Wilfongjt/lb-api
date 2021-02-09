
import Consts from '../../lib/constants/consts.js';
import { ChelatePattern } from '../../lib/chelates/chelate_pattern.js';

describe('ChelatePattern', () => {
  // Initialize
  test('ChelatePattern No Change', () => {
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
    let pattern = new ChelatePattern(chelate);
    //console.log('pattern',pattern);
    expect(pattern.pk).toBeTruthy();
    expect(pattern.sk).toBeTruthy();
    expect(pattern.tk).toBeTruthy();
    expect(pattern.keyChanged()).toBeFalsy();
    expect(pattern).toEqual({pk: {"att":"username"}, sk:{"const":"USER"}, tk:{"guid":"520a5bd9-e669-41d4-b917-81212bc184a3"}});
  })

  test('ChelatePattern Form Change', () => {
    let chelate = {
      pk: "username#abc@xyz.com",
      sk: "const#USER",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc@xyz.com",
         "displayname":"abc changed",
         "password":"a1A!aaaa"
      }
    };
    let pattern = new ChelatePattern(chelate);
    //console.log('pattern',pattern);
    expect(pattern.pk).toBeTruthy();
    expect(pattern.sk).toBeTruthy();
    expect(pattern.tk).toBeTruthy();
    expect(pattern.pk).toEqual({"att": "username"});
    expect(pattern.sk).toEqual({"const": "USER"});
    expect(pattern.tk).toEqual({"guid": "520a5bd9-e669-41d4-b917-81212bc184a3"});

    expect(pattern.keyChanged()).toBeFalsy();
  })


  test('ChelatePattern PK SK Change', () => {
    let chelate = {
      pk: "username#abc@xyz.com",
      sk: "displayname#abc",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
        "username":"abc-changed@xyz.com",
         "displayname":"abc changed",
         "password":"a1A!aaaa"
      }
    };
    let pattern = new ChelatePattern(chelate);
    //console.log('pattern',pattern);
    //console.log('pattern.keyChanged()', pattern.keyChanged(), pattern.get('keyChanged'));
    expect(pattern.pk).toBeTruthy();
    expect(pattern.sk).toBeTruthy();
    expect(pattern.tk).toBeTruthy();

    expect(pattern.pk).toEqual({att: 'username', keyChanged:true});
    expect(pattern.sk).toEqual({att: 'displayname', keyChanged:true});
    expect(pattern.tk).toEqual({"guid": "520a5bd9-e669-41d4-b917-81212bc184a3"});

    expect(pattern.keyChanged()).toEqual(true);

  })

  test('ChelatePattern SK TK Change', () => {
    let chelate = {
      sk: "displayname#abc",
      tk: "guid#520a5bd9-e669-41d4-b917-81212bc184a3",
      form: {
         "password":"a1A!aaaa"
      }
    };
    let pattern = new ChelatePattern(chelate);
    //console.log('test ChelatePattern pattern',pattern);
    //console.log('pattern.keyChanged()', pattern.keyChanged(), pattern.get('keyChanged'));
    //expect(pattern.pk).toBeTruthy();
    expect(pattern.sk).toBeTruthy();
    expect(pattern.tk).toBeTruthy();

    //expect(pattern.pk).toEqual({att: 'username'});
    expect(pattern.sk).toEqual({att: 'displayname'});
    expect(pattern.tk).toEqual({"guid": "520a5bd9-e669-41d4-b917-81212bc184a3"});

    expect(pattern.keyChanged()).toEqual(false);

  })

  test('ChelatePattern getKeyMap', () => {
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
    let pattern = new ChelatePattern(chelate);
    //console.log('pattern.keyMap()',pattern.keyMap());
    expect(pattern.getKeyMap()).toBeDefined();
    expect(pattern.getKeyMap()).toEqual({pk: {"att":"username"}, sk:{"const":"USER"}, tk:{"guid":"520a5bd9-e669-41d4-b917-81212bc184a3"}});

  })

});
