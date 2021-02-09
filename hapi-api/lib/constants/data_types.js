export default class DataTypes {

  static userType() {
    return 'const#USER';
  }
  static aliasType() {
    return 'const#ALIAS';
  }
  static in(typeName) {
    switch(typeName) {
      case 'const#USER': return true; break;
    }
    return false;
  }
}
