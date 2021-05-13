export class ConnectionConfig {
  //constructor(user={user:"<user>",password:"<password>"},
  //            database={host:"<host>",port:"<port>",database:"<database>"},
  //            token='<token>') {
  constructor(user={},
              database={},
              token='<token>') {
    this['user']=user.user || '<user>';
    this['password']=user.password || '<password>';
    this['host']=database.host || '<host>';
    this['database']=database.database || '<database>';
    this['port']=database.port || '<port>';
    this['quest_token']=token || '<jwt-token>';
  }
  toString() {
    return 'postgresql://%user:%pw@%host:%port/%database'
                    .replace('%user',this.user)
                    .replace('%pw',this.password)
                    .replace('%host',this.host)
                    .replace('%port',this.port)
                    .replace('%database',this.database);

  }
}
