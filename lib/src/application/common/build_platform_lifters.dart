import 'dart:io';

import 'detect_platforms.dart';
import '../platform/build_platform_lifter.dart';
import '../../domain/constraints/project_platform.dart';

import '../../domain/abs/platform_lifter.dart';

Future<Map<ProjectPlatform, PlatformLifter>> buildPlatformLifters(
  Directory root,
) async {
  final platforms = await detectPlatforms(root);

  return Map.fromEntries(platforms.map((e) => MapEntry(e, e.buildLifter())));
}
