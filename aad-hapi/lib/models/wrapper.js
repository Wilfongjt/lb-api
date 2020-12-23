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
