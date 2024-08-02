import 'dart:io';

import 'package:version_lifter/src/application/info/parse_pubspec.dart';

import '../../domain/abs/platform_lifter.dart';
import '../../domain/constraints/project_platform.dart';
import '../../domain/typedefs.dart';

Future<PackageInfo> gatherInfo(Directory root, Map<ProjectPlatform, PlatformLifter> lifters) async {
  final platformInfos = Future.wait(
    lifters.entries.map(
      (e) async => (e.key, await e.value.gatherInfo(root)),
    ),
  );

  return (
    pubspec: await parsePubspec(root),
    platforms: await platformInfos,
  );
}
