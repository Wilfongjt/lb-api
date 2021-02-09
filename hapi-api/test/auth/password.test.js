
import { Password } from '../../lib/auth/password.js';

describe('Password', () => {
  // Initialize
  test('new Password', () => {
   let form = {
     "username":"abc@xyz.com",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };

    expect(new Password()).toBeDefined();

  })

  test('Hash Password', () => {
   //let dataTypes = new DataTypes();
   let form = {
     "username":"abc@xyz.com",
      "displayname":"abc",
      "password":"a1A!aaaa"
    };

    let password = new Password();
    form.password = password.hashify(form.password);
    ///console.log('form.password', form.password);

    expect(form.password.hash).toBeDefined();
    expect(form.password.salt).toBeDefined();

  })
  test('Verify Hashed Password', () => {
   let mypass = "a1A!aaaa";
   let form = {
     "username":"abc@xyz.com",
      "displayname":"abc",
      "password":mypass
    };

    let password = new Password();
    form.password = password.hashify(form.password);
    //console.log('form.password', form.password);

    expect(password.verify('a1A!aaaa', form.password)).toBeTruthy();
    expect(password.verify('x1X!xxxx', form.password)).toBeFalsy();

  })

});
