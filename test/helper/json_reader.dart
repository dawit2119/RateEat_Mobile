import 'dart:io';

String readJson(String name) {
  return File('test/helper/$name').readAsStringSync();
}
