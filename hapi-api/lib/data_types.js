export default class DataTypes {

  static userType() {
    return 'USER';
  }
  static aliasType() {
    return 'ALIAS';
  }
  static in(typeName) {
    switch(typeName) {
      case 'USER': return true; break;
      case 'ALIAS': return true; break;
    }
    return false;
  }
}
