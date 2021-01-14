exports.MockResponse = function () {
  this.resp = {isValid: false, results: {}};
  this.response = (json_obj) => {
    this.resp.results=JSON.parse(JSON.stringify(json_obj));
    return this;
  };
  this.code = (num) => {
    this.resp.code=num;
    this.isValid = false;
    if (num === 200){
      this.resp.isValid=true;
    }
    return this.resp;
  };
};
