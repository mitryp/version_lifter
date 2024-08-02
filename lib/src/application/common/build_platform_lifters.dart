import 'dart:io';

import 'package:version_lifter/src/application/common/detect_platforms.dart';
import 'package:version_lifter/src/application/platform/build_platform_lifter.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../../domain/abs/platform_lifter.dart';

Future<Map<ProjectPlatform, PlatformLifter>> buildPlatformLifters(
  Directory root,
) async {
  final platforms = await detectPlatforms(root);

  return Map.fromEntries(platforms.map((e) => MapEntry(e, e.buildLifter())));
}
