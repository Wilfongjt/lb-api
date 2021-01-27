import TokenPayload  from '../lib/token_payload.js';

export default class TestData {
  constructor() {
    /*this.aud='api-client';
    this.iss='lyttlebit';
    this.token_payload = {
        aud: this.aud,
        iss: this.iss,
        sub: false,
        user: 'guest',
        scope: ['guest']
    };
    */
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
  user_TokenPayload(username, id, scope) {
    return new TokenPayload()
                 .user(username)
                 .iid(id)
                 .scope(scope)
                 .payload();
  }
};


/*
export default class TestData {
  constructor() {
    this.aud='api-client';
    this.iss='lyttlebit';
    this.token_tmpl = {
        aud: this.aud,
        iss: this.iss,
        sub: false,
        user: 'guest',
        iid: '',
        scope: ['guest']
    };
  }

  // user post payload
  getTokenPayload(user, scopes, aud='api-client',iss='lyttlebit',iid=null) {
    // scopes is an array i.e. ['guest']
    rc = {
        aud: aud,
        iss: iss,
        sub: false,
        user: user,
        scope: scopes
    };
    if (! iid) {
      rc.iid = iid;
    }
    return rc;
  }

  badIss_TokenPayload() {
    return {
        aud: this.aud,
        iss: 'bad-iss-claim-value',
        sub: false
    };
  }
  missingIss_TokenPayload() {
    return {
        aud: this.aud,

        sub: false
    };
  }
  badAud_TokenPayload() {
    return {
        aud: 'bad-aud-claim-value',
        iss: this.iss,
        sub: false
    };
  }
  missingAud_TokenPayload() {
    return {

        iss: this.iss,
        sub: false
    };
  }
  guest_TokenPayload() {
    return this.getTokenPayload('guest',['guest']);
  }
  missingUser_TokenPayload() {

    return {
        aud: this.aud,
        iss: this.iss,
        sub: false,

        scope: ['guest']
    };
  }
  missingScope_TokenPayload() {
    return {
        aud: this.aud,
        iss: this.iss,
        sub: false,
        user: 'guest'

    };
  }
  user_TokenPayload(username, id) {
    return this.getTokenPayload(username, ['user']);
  }
};


*/
