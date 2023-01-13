library json_compress;

import 'dart:convert';
import 'dart:math';

import 'package:jpatch/jpatch.dart';
import 'package:threshold/threshold.dart';

/// Decompress a json object or just return it if it's not compressed
Map<String, dynamic> decompressJson(Map<String, dynamic> json,
    {bool ignoreWarnings = false, bool keepUnknownKeys = true}) {
  if (json.containsKey("_k0")) {
    String s = "";
    int l = json.length;
    for (int i = 0; i < l; i++) {
      if (json.containsKey("_k$i")) {
        dynamic m = json["_k$i"];

        if (m is String) {
          s += m;
        } else {
          if (!ignoreWarnings) {
            print(
                "Failed to decompress chunk $i. It was not a string but a ${m?.runtimeType ?? "null"}");
          }
          break;
        }
      } else {
        break;
      }
    }

    Map<String, dynamic> out = jsonDecode(decompress(s));

    if (keepUnknownKeys) {
      out = out.flattened();
      json = json.flattened();
      json.forEach((key, value) {
        if (!key.startsWith("_k")) {
          out[key] = value;
        }
      });
      json = json.expanded();
      out = out.expanded();
    }

    return out;
  }

  return json;
}

Map<String, dynamic> _compressAllJson(Map<String, dynamic> json,
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

typedef JsonCompressionRetainerPredicate = bool Function(
    String key, dynamic value);

/// Compresses a JSON object
/// The split parameter is the maximum size of each chunk
///
/// If the compressed size is bigger than the original size, it will return the original object
/// unless forceEncode is enabled, in which case it will return a non-compressed base64 chunked object
/// You can use a key retainer to only compress keys not included in the predicate. Force encoded is force-enabled if a retainer is used
Map<String, dynamic> compressJson(Map<String, dynamic> json,
    {int split = 8192,
    bool forceEncode = false,
    JsonCompressionRetainerPredicate? retainer}) {
  if (retainer != null) {
    Map<String, dynamic> search = json.flattened();
    Map<String, dynamic> compress = json.flattened();
    Map<String, dynamic> retain = json.flattened();

    for (String i in search.keys.toList()) {
      if (!retainer(i, search[i])) {
        retain.remove(i);
      } else {
        compress.remove(i);
      }
    }

    compress =
        _compressAllJson(compress.expanded(), split: split, forceEncode: true);
    retain = retain.expanded();
    compress.addAll(retain);
    return compress;
  }

  return _compressAllJson(json, split: split, forceEncode: forceEncode);
}
