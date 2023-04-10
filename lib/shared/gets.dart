String getId(String str) {
  return str.substring(0, str.indexOf("_"));
}

String getName(String str) {
  return str.substring(str.indexOf("_") + 1);
}
