// guest is an application guest that can post to the /user route
// user is an application user that can interact with a single account
export default class TokenPayload {
  constructor() {
    this.token_payload = {
        aud: 'api-client',
        iss: 'lyttlebit',
        sub: false,
        user: 'guest',
        scope: ['guest']
    };
  }
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
      this.token_payload.assign(scope);
    } else if (typeof(scope) === 'object') {
      this.token_payload.scope = scope;
    }
    return this;
  }
  iid(iid) {
    this.token_payload.iid = iid;
    return this;
  }
}
