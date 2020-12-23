const { v4: uuidv4 } = require('uuid');
// const Messages = require('../models/messages');
const Password = require('../password');
const Adopter = require('../models/adopter_model');
const Messages = require('../models/messages');
const DataHandler = require('./json_handler');
const Wrapper = require('../models/wrapper');
/*
GET
*/
/*
exports.get = (request, h) => {

  return Dog.findById(req.params.id).exec().then((dog) => {

    if(!dog) return { message: 'Dog not Found' };

    return { dog: dog };

  }).catch((err) => {

    return { err: err };

  });
}
*/
/*
POST
*/
//const adopter = (request, h) => {
exports.create = (request, h) => {
    const payload = request.payload;  // request payload
    let saltRounds = 12;              // used for hashing password
    const uuid_ = uuidv4();           // use to generate uuid for item
    //let results = JSON.parse(JSON.stringify(stub_results)); // make copy of expected data
    let results = Messages.results();
    try {

      //const _datetime = new Date();
      // reorganize payload
      payload.id = payload.username;
      payload.key = uuid_;
      payload.name = payload.username;
      payload.type = "adopter";
      payload.password = Password.hash(payload.password, saltRounds);
      // enclose in a wrapper
      const wrapper = Wrapper.wrapper();
      wrapper.pk = payload.username;
      wrapper.sk = "profile#%s".replace('%s',payload.username);
      wrapper.data = "adopter";
      wrapper.form = payload;

      /////////////////////////////////////
      // Store object
      // this is an adhoc solution
      // swap in your data solution here
      DataHandler.getJson('./lib/development_data.json')
              .then(function(data){
                data.push(wrapper);
                DataHandler.setJson('./lib/development_data.json', data);
              });
      // end data storage
      /////////////////////////////////////

      ////////////////////////////////
      // begin preparing the response
      // remove the password
      delete payload.password;
      results.result=payload;

      return h.response(results.result)
               .code(200);
   }catch(err){
     console.log('adopter: ' + err);

   }

};

//exports.adopter = adopter;
