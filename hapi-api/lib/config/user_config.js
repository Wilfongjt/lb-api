export class UserConfig {
  constructor(jsonStr) {
    this['user']=JSON.parse(jsonStr)['user'];
    this['password']=JSON.parse(jsonStr)['password'];
  }
}
