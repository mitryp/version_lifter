import 'dart:io';

import 'package:path/path.dart' as path;

import '../../domain/constraints/project_platform.dart';

Future<Set<ProjectPlatform>> detectPlatforms(Directory root) async {
  final maybePlatforms = await root
      .list()
      .map((entity) => path.basename(entity.path))
      .map((name) => ProjectPlatform.namesToPlatforms[name])
      .toSet();

  return maybePlatforms.nonNulls.toSet();
}
