import 'dart:math';

import 'package:json_compress/json_compress.dart';
import 'package:test/test.dart';

void main() {
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
    expect(
        json,
        equals(decompressJson(
            compressJson(json, retainer: (k, v) => k.endsWith("e")))));
    expect(
        json,
        equals(decompressJson(
            compressJson(json, retainer: (k, v) => !k.contains("list")))));
    expect(
        json,
        equals(decompressJson(compressJson(json,
            retainer: (k, v) => Random().nextDouble() >= 0.5))));
  });
}
