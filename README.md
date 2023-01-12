Compresses Json Objects

## Features

Uses the threshold package to select the best compressor for the data. This is useful for compressing large json objects, but it can also handle small objects without too much loss.

### Basic Compression

An example object (270 chars minified)

```json
{
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
    "alist": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  }
}
```

Compressed using a chunk size of 64 (normally use 8192) is 197 chars. A block size of 8192 would make this only 170 chars, a 37% reduction from 270 chars.
```json
{
  "_k0": "^eAHFjsEOwjAMQ39lytlCjMHa9cZ3IA4dFFQUddLWcpn277jwEVwcvyixvIpf8hz",
  "_k1": "TU5ycm59t3l5LEIiPKYvr7EB7n8qogbTrjbGGm1RUxVUl5Jkfrirh4XUhfQdR48K",
  "_k2": "YS4sDOhxxQg8DiwHt_lpzpvEVbrxY_9xl2z6MMFKT"
}
```

### Force Encoding

If you are using something like firebase where the key count is billed but not exactly the size of each value, you can forceEncode the object with basic base64 if compression would make it larger

## Usage


```dart
import 'package:json_compress/json_compress.dart';

Map<String, dynamic> myJson = ...;
Map<String, dynamic> compressed = compressJson(myJson, 
    forceEncode: false // default is false, see force encoding above
    chunkSize: 8192 // default 
);
Map<String, dynamic> back = decompressJson(compressed);
```
