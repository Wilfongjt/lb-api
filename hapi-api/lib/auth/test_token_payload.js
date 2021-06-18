import TokenPayload  from './token_payload.js';

export default class TestTokenPayload {
  constructor() {
  }

  // user post payload

  badIss_TokenPayload() {
    return new TokenPayload()
                 .iss('bad-iss-claim-value')
                 .payload();
  }
  missingIss_TokenPayload() {
    return new TokenPayload()
                 .remove('iss')
                 .payload();
  }
  badAud_TokenPayload() {
    return new TokenPayload()
                 .aud('bad-aud-claim-value')
                 .payload();
  }
  missingAud_TokenPayload() {
    return (new TokenPayload())
                 .remove('aud')
                 .payload();
  }
  guest_TokenPayload() {
    return new TokenPayload()
                 .payload();
  }
  fake_guest_TokenPayload() {
    return new TokenPayload()
                 .payload();
  }
  missingUser_TokenPayload() {
    return new TokenPayload()
                 .remove('user')
                 .payload();
  }
  missingScope_TokenPayload() {
    return new TokenPayload()
                 .remove('scope')
                 .payload();
  }
  user_TokenPayload(username, key, scope) {
    if (!username){
      throw 'user_TokenPayload is requires a username';
    }
    if (!key){
      throw 'user_TokenPayload is requires a key';
    }
    if (!key.includes('#') ) {
      throw 'user_TokenPayload requires a key with a #, eg guid#somevalue';
    }
    if (!scope){
      throw 'user_TokenPayload is requires a scope';
    }
    return new TokenPayload()
                 .user(username)
                 .key(key)
                 .scope_(scope)
                 .payload();
  }
  admin_TokenPayload(username, key) {
    if (!username){
      throw 'admin_TokenPayload is requires a username';
    }
    if (!key){
      throw 'admin_TokenPayload is requires a key';
    }
    return new TokenPayload()
                 .user(username)
                 .key(key)
                 .scope_('api_admin')
                 .payload();
  }
  /*
  user_TokenPayload(username, id, scope) {
    return new TokenPayload()
                 .user(username)
                 .iid(id)
                 .scope(scope)
                 .payload();
  }
  */
};
