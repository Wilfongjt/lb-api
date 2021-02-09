import crypto from 'crypto';

export class Password {
  constructor() {  }

  hashify(password) {
    let hash;
    let salt;
    //console.log('password.hashify', password);
    if (typeof(password) === 'string') {
      salt = crypto.randomBytes(16).toString('hex');
      hash = crypto.pbkdf2Sync(password,
                               salt,
                               1000,
                               64,
                               `sha512`).toString(`hex`);
    } else { // reuse the existing pw
      salt = password.salt;
      hash = password.hash;
    }

    //console.log('password.hashify out')
    return {hash:hash, salt:salt};
  }

  verify(password, passwordObject) {
    // passwordObject = {hash: "", salt:""}
    //console.log('Password.verify', password, passwordObject);
    let hash = crypto.pbkdf2Sync(password,
    passwordObject.salt, 1000, 64, `sha512`).toString(`hex`);
    return passwordObject.hash === hash;
  }
};
