exports.wrapper = function() {
  let _datetime = new Date();
  return {
      "pk": "",
      "sk": "",
      "data": "",
      "form": {},
      "uuid":"", // dont need
      "active": true,
      "created": _datetime.toISOString(),
      "updated": _datetime.toISOString()
  };
};
/*
exports.wrapper = wrapper;

const wrapper = function() {
  let _datetime = new Date();
  return {
      "pk": "",
      "sk": "",
      "data": "",
      "form": {},
      "active": true,
      "created": _datetime,
      "updated": _datetime
  };
};
exports.wrapper = wrapper;
*/
