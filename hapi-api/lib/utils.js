export default class Utils {
  static size(objJson) {
    // size in bytes
    return encodeURI(JSON.stringify(objJson).split(/%..|./).length - 1);

  }
}
