// guest is an application guest that can post to the /user route
// user is an application user that can interact with a single account
export default class TokenPayload {
  constructor(aud='lyttlebit-api',iss='lyttlebit',sub='client-api',user='guest',scope='api_guest',key='0') {
  //constructor(aud='api-client',iss='lyttlebit',sub='client-api',user='guest',scope='api_guest',key='0') {
  // aud, iss, and sub are also set in server.js
  // and in .env
    this.token_payload = {
        aud: aud,
        iss: iss,
        sub: sub,
        user: user,
        scope: scope,
        key: key
    };
  }
  /*
  constructor() {
    this.token_payload = {
        aud: 'api-client',
        iss: 'lyttlebit',
        sub: false,
        user: 'guest',
        scope: ['api_guest']
    };
  }
  */
  payload() {
    //return JSON.stringify(this.token_payload) ;
    return this.token_payload;
  }
  remove(claim) {
    delete this.token_payload[claim];
    return this;
  }
  aud(aud){
    this.token_payload.aud=aud;
    return this;
  }
  iss(iss){
    this.token_payload.iss=iss;
    return this;
  }
  sub(sub){
    this.token_payload.sub=sub;
    return this;
  }
  user(user){
    this.token_payload.user=user;
    return this;
  }
  scope(scope){
    if (typeof(scope) === 'string') {

      //this.token_payload.assign(scope);
      this.token_payload.scope=scope;
    } else if (typeof(scope) === 'object') {
      this.token_payload.scope = scope;
    }
    return this;
  }
  key(key) {
    this.token_payload.key = key;
    return this;
  }
}
