const { v4: uuidv4 } = require('uuid');
// const Messages = require('../models/messages');
const Password = require('../password');
const Adopter = require('../models/adopter_model');
const Messages = require('../models/messages');
const Client = require('./%s_client'.replace('%s', process.env.LB_BACKEND));
const Wrapper = require('../models/wrapper');


exports.AdopterHandler = function () {
  /*
  POST
  */
  this.insert = (request, h) => {
      const payload = request.payload;  // request payload
      let saltRounds = 12;              // used for hashing password
      const uuid_ = uuidv4();           // use to generate uuid for item
      //let results = JSON.parse(JSON.stringify(stub_results)); // make copy of expected data
      try {
        let client = null;
        if( process.env.LB_BACKEND === 'json') {
          client = new Client({path: "../../data/development_data.json"}); 
        }
        //client = new Client(JSON.parse(process.env.LB_CONNECTION_STR).replace('%s',''));
        client.connect();
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
        wrapper.id = uuid_ ;
        /////////////////////////////////////
        // Store object
        // this is an adhoc solution
        // swap in your data solution here
        client.insert(wrapper);
        // end data storage
        /////////////////////////////////////
        ////////////////////////////////
        // begin preparing the response
        // remove the password
        let results = Messages.results();
        results.results = JSON.parse(JSON.stringify(payload));

        delete results.results.password;
        //console.log('results',results);
        //results.result=payload;

        return h.response(results)
                 .code(200);
     }catch(err){
       console.log('AdopterHandler: ' + err);
       return h.response({isValid: false})
                .code(400);
     }
  };
}
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
/*
exports.insert = (request, h) => {
    const payload = request.payload;  // request payload
    let saltRounds = 12;              // used for hashing password
    const uuid_ = uuidv4();           // use to generate uuid for item
    //let results = JSON.parse(JSON.stringify(stub_results)); // make copy of expected data
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
      wrapper.id = uuid_ ;
      /////////////////////////////////////
      // Store object
      // this is an adhoc solution
      // swap in your data solution here
      Client.insert(wrapper);
      // end data storage
      /////////////////////////////////////
      ////////////////////////////////
      // begin preparing the response
      // remove the password
      let results = Messages.results();
      results.results = JSON.parse(JSON.stringify(payload));

      delete results.results.password;
      //console.log('results',results);
      //results.result=payload;

      return h.response(results)
               .code(200);
   }catch(err){
     console.log('adopter: ' + err);
     return h.response({isValid: false})
              .code(400);
   }
};
*/
/*
PUT
*/


/*
DELETE
*/
