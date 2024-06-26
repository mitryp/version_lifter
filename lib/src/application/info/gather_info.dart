import 'dart:io';

import 'package:version_lifter/src/application/info/detect_platforms.dart';
import 'package:version_lifter/src/application/info/parse_pubspec.dart';

import '../../domain/typedefs.dart';

Future<PackageInfo> gatherInfo(Directory root) async {
  return (
    pubspec: await parsePubspec(root),
    platforms: await detectPlatforms(root),
  );
}
