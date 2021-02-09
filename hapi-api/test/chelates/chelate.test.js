import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../../.env') });
}
import Consts from '../../lib/constants/consts.js';

import DataTypes from '../../lib/constants/data_types.js';
import { Chelate } from '../../lib/chelates/chelate.js';

/* New
PK SK TK must have all
ATT ATT ATT must convert to PK SK TK
CONST CONST CONST must convert to PK SK TK
GUID GUID GUID must convert to PK SK TK
* * * must convert to PK SK TK

* is a calculated GUID



PK + SK must be unique

test   PK    SK    TK          obvious issues
       ----- ----- ----------- ---------
Y      Empty                   ok

-      ATT                     exception(Missing SK)
-            ATT               exception(Missing PK)
-                  ATT         exception(Missing PK)
-            ATT   ATT         exception(Missing PK)
-      ATT   ATT               exception(Missing TK)
y      ATT   ATT   ATT   form  ok
-      ATT   ATT   CONST form  ok
-      ATT   ATT   GUID  form  ok
-      ATT   CONST ATT   form  ok
-      ATT   CONST CONST form  ok
y      ATT   CONST GUID  form  ok
-      ATT   GUID  ATT   form  ok
-      ATT   GUID  CONST form  ok
-      ATT   GUID  GUID  form  ok

-      CONST                   exception(Missing SK)
-            CONST             exception(Missing PK)
-                  CONST       exception(Missing PK)
-            CONST   CONST     exception(Missing PK)
-      CONST   CONST           exception(Missing TK)
-      CONST CONST CONST form  same as ATT ATT ATT
-      CONST CONST ATT   form  same as ATT ATT ATT
-      CONST CONST GUID  form  same as ATT ATT ATT
-      CONST ATT   ATT   form  ok
-      CONST ATT   CONST form  same as ATT ATT ATT
-      CONST ATT   GUID  form  same as ATT ATT ATT
-      CONST GUID  CONST form  same as ATT ATT ATT
-      CONST GUID  ATT   form  same as ATT ATT ATT
-      CONST GUID  GUID  form  same as ATT ATT ATT

-      GUID              form  exception(Missing SK)
-            GUID        form  exception(Missing PK)
-                  GUID  form  exception(Missing PK)
-            GUID  GUID  form  exception(Missing PK)
-      GUID  GUID        form  exception(Missing TK)
-      GUID  GUID  GUID  form  exception(Infinite)
-      GUID  GUID  ATT   form
-      GUID  GUID  CONST form
-      GUID  ATT   ATT   form
-      GUID  ATT   CONST form
-      GUID  ATT   GUID  form
-      GUID  CONST ATT   form
-      GUID  CONST CONST form
-      GUID  CONST GUID  form
-
-      ATT   CONST GUID  form
-      ATT   GUID  CONST form
-      CONST ATT   GUID  form
-      CONST GUID  ATT   form
-      GUID  ATT   CONST form
-      GUID  CONST ATT   form

*/
describe('Chelate', () => {
  // Initialize

  let key_map_user = {
    pk:{att: "username"},
    sk:{const: "USER"},
    tk:{guid: "*"}        // * is flag to calculate guid
  };

  let att_att_att = {
    pk:{att: "username"},
    sk:{att: "displayname"},
    tk:{att: "password"}
  };
  let const_const_const = {
    pk:{const: "USER1"},
    sk:{const: "USER2"},
    tk:{const: "USER3"}
  };
  let guid_guid_guid = {
    pk:{guid: "520a5bd9-e669-41d4-b917-81212bc184a3"},
    sk:{guid: "620a5bd9-e669-41d4-b917-81212bc184a3"},
    tk:{guid: "720a5bd9-e669-41d4-b917-81212bc184a3"}
  };
  let star_star_star = { // aka guid_guid_guid
    pk:{guid: "*"},
    sk:{guid: "*"},
    tk:{guid: "*"}
  };
  test('New Chelate() empty', () => {

    let chelateObj = new Chelate();

    expect(chelateObj).toBeDefined();
    expect(chelateObj.pk).not.toBeDefined();
    expect(chelateObj.sk).not.toBeDefined();
    expect(chelateObj.tk).not.toBeDefined();
    expect(chelateObj.form).not.toBeDefined();
    expect(chelateObj.active).not.toBeDefined();
    expect(chelateObj.created).not.toBeDefined();
    expect(chelateObj.updated).not.toBeDefined();
  })

  test('New Chelate({ATT ATT ATT} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(att_att_att, form);

    expect(chelate).toBeDefined();

    expect(chelate.pk).toEqual('username#abc@xyz.com');
    expect(chelate.sk).toEqual('displayname#abc');
    expect(chelate.tk).toEqual('password#a1A!aaaa');
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
    expect(chelate.toJson().form.username).toEqual('abc@xyz.com');
    expect(chelate.toJson().form.displayname).toEqual('abc');
    expect(chelate.toJson().form.password).toEqual('a1A!aaaa');
    expect(chelate.toJson().active).toEqual(true);
    expect(chelate.toJson().created).toBeDefined();
    expect(chelate.toJson().updated).toBeDefined();

  })

  test('New Chelate({CONST CONST CONST} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(const_const_const, form);

    expect(chelate).toBeDefined();

    expect(chelate.pk).toEqual('const#USER1');
    expect(chelate.sk).toEqual('const#USER2');
    expect(chelate.tk).toEqual('const#USER3');
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
    expect(chelate.toJson().form.username).toEqual('abc@xyz.com');
    expect(chelate.toJson().form.displayname).toEqual('abc');
    expect(chelate.toJson().form.password).toEqual('a1A!aaaa');
    expect(chelate.toJson().active).toEqual(true);
    expect(chelate.toJson().created).toBeDefined();
    expect(chelate.toJson().updated).toBeDefined();

  })
  test('New Chelate({GUID GUID GUID} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(guid_guid_guid, form);

    expect(chelate).toBeDefined();

    expect(chelate.pk).toEqual('guid#520a5bd9-e669-41d4-b917-81212bc184a3');
    expect(chelate.sk).toEqual('guid#620a5bd9-e669-41d4-b917-81212bc184a3');
    expect(chelate.tk).toEqual('guid#720a5bd9-e669-41d4-b917-81212bc184a3');
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
    expect(chelate.toJson().form.username).toEqual('abc@xyz.com');
    expect(chelate.toJson().form.displayname).toEqual('abc');
    expect(chelate.toJson().form.password).toEqual('a1A!aaaa');
    expect(chelate.toJson().active).toEqual(true);
    expect(chelate.toJson().created).toBeDefined();
    expect(chelate.toJson().updated).toBeDefined();

  })

  test('New Chelate({* * *} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(guid_guid_guid, form);

    expect(chelate).toBeDefined();

    expect(chelate.pk).toMatch(new RegExp(Consts.guidPlusPattern()));
    expect(chelate.sk).toMatch(new RegExp(Consts.guidPlusPattern()));
    expect(chelate.tk).toMatch(new RegExp(Consts.guidPlusPattern()));
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
    expect(chelate.toJson().form.username).toEqual('abc@xyz.com');
    expect(chelate.toJson().form.displayname).toEqual('abc');
    expect(chelate.toJson().form.password).toEqual('a1A!aaaa');
    expect(chelate.toJson().active).toEqual(true);
    expect(chelate.toJson().created).toBeDefined();
    expect(chelate.toJson().updated).toBeDefined();

  })

/*
removed the .update(form) method
    test('update(form) Chelate(whatever and form).update(form)', () => {
     let form = {
       "username":"abc@xyz.com",
       "displayname":"abc",
       "password":"a1A!aaaa"
      };
      let form1 = {
        "username":"ABC@xyz.com",
        "displayname":"ABC",
        "password":"A1a!AAAA"
       };
      let chelate = new Chelate(att_att_att, form).update(form1);

      expect(chelate).toBeDefined();
      expect(chelate.pk).toEqual("username#abc@xyz.com");
      expect(chelate.sk).toEqual("displayname#abc");
      expect(chelate.tk).toEqual("password#a1A!aaaa");
      expect(chelate.form.username).toEqual("ABC@xyz.com");
      expect(chelate.form.displayname).toEqual("ABC");
      expect(chelate.form.password).toEqual("A1a!AAAA");

    })
*/
    test('toJson() Chelate(whatever and form).toJson()', () => {
     let form = {
       "username":"abc@xyz.com",
       "displayname":"abc",
       "password":"a1A!aaaa"
      };

      let jsonObj = new Chelate(att_att_att, form).toJson();

      expect(typeof(jsonObj)).toEqual('object');

    })


  ////////////////////////////////////////////////////
  /*
  test('New Chelate(key_map_user, chelate)', () => {
   let form = {
     "username":"abc@user.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };
    let chelate = {
      pk: "username#abc@user.com",
      sk: "const#USER",
      tk: "guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      form: form
    }

    let chelateObj = new Chelate(key_map_user,chelate);

    expect(chelateObj).toBeDefined();
    expect(chelateObj.pk).toEqual('username#abc@user.com');
    expect(chelateObj.sk).toEqual('const#USER');
    expect(chelateObj.tk).toBeDefined();
    expect(chelateObj.tk).toMatch(new RegExp(Consts.guidPlusPattern(),'i') );
    expect(chelateObj.form.username).toEqual('abc@user.com');
    expect(chelateObj.form.displayname).toEqual('abc');
    expect(chelateObj.form.password).toEqual('a1A!aaaa');
    expect(chelateObj.active).toEqual(true);
    expect(chelateObj.created).toBeDefined();
    expect(chelateObj.updated).toBeDefined();
  })

  test('New Chelate({ATT CONST *} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };
    let key_map = {
      pk:{att: "username"},
      sk:{const: "USER"},
      tk:{guid: "*"}        // * is flag to calculate guid
    };
    let chelate = new Chelate(att_const_guid, form);
    //console.log('chelate', chelate);
    expect(chelate).toBeDefined();
    expect(chelate.pk).toEqual('username#abc@xyz.com');
    expect(chelate.sk).toEqual('const#USER');
    expect(chelate.tk).toBeDefined();
    expect(chelate.tk).toMatch(new RegExp(Consts.guidPlusPattern(),'i') );
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');

  })


  test('Chelate.assign(form) ', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    // make an object
    let chelate_original = new Chelate(att_att_att, form);
    // fill an empty object
    let chelate = new Chelate().assign(chelate_original);

    expect(chelate).toBeDefined();
    expect(chelate.pk).toEqual('username#abc@xyz.com');
    expect(chelate.sk).toEqual('displayname#abc');
    expect(chelate.tk).toEqual('password#a1A!aaaa');
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
    expect(chelate.toJson().form.username).toEqual('abc@xyz.com');
    expect(chelate.toJson().form.displayname).toEqual('abc');
    expect(chelate.toJson().form.password).toEqual('a1A!aaaa');
    expect(chelate.toJson().active).toEqual(true);
    expect(chelate.toJson().created).toBeDefined();
    expect(chelate.toJson().updated).toBeDefined();

  })

  test('Chelate.toString()', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(att_att_att, form);
    expect(chelate).toBeDefined();
    expect(chelate.toString()).toBeDefined();
  })

  test('New Chelate({ATT CONST *} and form)', () => {
   let form = {
     "username":"abc@xyz.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };

    let chelate = new Chelate(att_const_guid, form);
    //console.log('chelate', chelate);
    expect(chelate).toBeDefined();
    expect(chelate.pk).toEqual('username#abc@xyz.com');
    expect(chelate.sk).toEqual('const#USER');
    expect(chelate.tk).toEqual('guid#520a5bd9-e669-41d4-b917-81212bc184a3');
    expect(chelate.form.username).toEqual('abc@xyz.com');
    expect(chelate.form.displayname).toEqual('abc');
    expect(chelate.form.password).toEqual('a1A!aaaa');

  })



  test('Chelate({ATT CONST GUID} and chelate).update(form) ', () => {

   let form1 = {
     "username":"abc@user.com",
     "displayname":"abc",
     "password":"a1A!aaaa"
    };
    let chelate1 = {
      pk: "username#abc@user.com",
      sk: "const#USER",
      tk: "guid#820a5bd9-e669-41d4-b917-81212bc184a3",
      form: form1
    }

    let form2 = {
      "username":"abc2@user.com",
      "displayname":"abc2",
      "password":"b1B!bbbb"
     };

    let chelate = new Chelate(att_const_guid,chelate1).update(form2);
    //console.log('chelate', chelate);
    //expect(chelateObj._guessFormType(key_map, chelate)).toEqual(1);
    expect(chelate).toBeDefined();
    expect(chelate.pk).toEqual('username#abc@user.com');
    expect(chelate.sk).toEqual('const#USER');
    expect(chelate.tk).toBeDefined();
    expect(chelate.tk).toMatch(new RegExp(Consts.guidPlusPattern(),'i') );
    expect(chelate.form.username).toEqual('abc2@user.com');
    expect(chelate.form.displayname).toEqual('abc2');
    expect(chelate.form.password).toEqual('b1B!bbbb');
    expect(chelate.active).toEqual(true);
    expect(chelate.created).toBeDefined();
    expect(chelate.updated).toBeDefined();
  })
*/

});
