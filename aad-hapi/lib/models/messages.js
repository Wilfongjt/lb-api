// const datetime = require('node-datetime');


const results = function() {
  return {
    isValid:true,    // JWT status
    credentials: {}, // user identification
    results: {}      // output from endpoint process
  };
};
const expected_claims = function() {
  return {
       aud: "lyttlebit-client",
       iss: "lyttlebit",
       sub: "app-api"
  };
};
exports.results = results;
exports.expected_claims = expected_claims;
