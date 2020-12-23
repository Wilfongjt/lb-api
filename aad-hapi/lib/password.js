const crypto = require('crypto');

const hash = function(password, rounds) {
  /*
  create and return a hashed password
  */
  try {
    if (rounds >= 15) {
        throw new Error(`${rounds} is greater than 15,Must be less that 15`);
    }
    if (typeof rounds !== 'number') {
        throw new Error('rounds param must be a number');
    }
    if (rounds == null) {
        rounds = 12;
    }
    let salt = crypto.randomBytes(Math.ceil(rounds / 2)).toString('hex').slice(0, rounds);
    let hash = crypto.createHmac('sha512', salt);
    hash.update(password);
    let value = hash.digest('hex');
    return {
        salt: salt,
        hash: value
    };
  }catch (err) {
    console.log('hashPassword: ' + err);
    return { isValid: false };
  }
};
exports.hash = hash;
