
exports.results = function() {
  return {
    isValid:true,    // JWT status
    // credentials: {}, // user identification
    results: {}      // output from endpoint process
  };
};
exports.expected_claims = function() {
  return {
       aud: "lyttlebit-client",
       iss: "lyttlebit",
       sub: "app-api"
  };
};
