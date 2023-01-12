library json_compress;

import 'dart:convert';
import 'dart:math';

import 'package:threshold/threshold.dart';

/// Decompress a json object or just return it if it's not compressed
Map<String, dynamic> decompressJson(Map<String, dynamic> json) {
  if (json.containsKey("_k0")) {
    String s = "";
    for (int i = 0; i < json.length; i++) {
      s += json["_k$i"];
    }

    return jsonDecode(decompress(s));
  }

  return json;
}

/// Compresses a JSON object
/// The split parameter is the maximum size of each chunk
///
/// If the compressed size is bigger than the original size, it will return the original object
/// unless forceEncode is enabled, in which case it will return a non-compressed base64 chunked object
Map<String, dynamic> compressJson(Map<String, dynamic> json,
    {int split = 8192, bool forceEncode = false}) {
  String compressed = compress(jsonEncode(json), forceEncode: forceEncode);
  Map<String, dynamic> map = {};
  int g = 0;
  for (int i = 0; i < compressed.length; i += split) {
    map["_k${g++}"] =
        compressed.substring(i, min(i + split, compressed.length));
  }

  return map;
}
