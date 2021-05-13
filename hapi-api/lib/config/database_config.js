export class DatabaseConfig {
  constructor(jsonStr) {
    this['host']=JSON.parse(jsonStr)['host'];
    this['port']=JSON.parse(jsonStr)['port'];
    this['database']=JSON.parse(jsonStr)['database'];
  }
}
