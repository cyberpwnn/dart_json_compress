import 'dart:convert';

import 'package:json_compress/json_compress.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> jsonx = {
    "astring": "A string value",
    "aint": 389,
    "adouble": 3.67787,
    "anull": null,
    "atrue": true,
    "afalse": false,
    "alist": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "anobject": {
      "astring": "A string value",
      "aint": 389,
      "adouble": 3.67787,
      "anull": null,
      "atrue": true,
      "afalse": false,
      "alist": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    },
  };

  String a = jsonEncode(jsonx);
  String b = jsonEncode(compressJson(jsonx, split: 64));
  print("${a.length} chars: $a");
  print("${b.length} chars: $b");

  test('Test forceencode / empty compression', () {
    Map<String, dynamic> json = {};
    expect(json, equals(decompressJson(compressJson(json))));
    expect(json, equals(decompressJson(compressJson(json, forceEncode: true))));
  });

  test('Test  compression', () {
    Map<String, dynamic> json = {
      "astring": "A string value",
      "aint": 389,
      "adouble": 3.67787,
      "anull": null,
      "atrue": true,
      "afalse": false,
      "alist": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      "anobject": {
        "astring": "A string value",
        "aint": 389,
        "adouble": 3.67787,
        "anull": null,
        "atrue": true,
        "afalse": false,
        "alist": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      },
    };
    expect(json, equals(decompressJson(compressJson(json))));
    expect(json, equals(decompressJson(compressJson(json, forceEncode: true))));
  });
}
