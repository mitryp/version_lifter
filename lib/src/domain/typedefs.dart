import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'abs/platform_info.dart';
import 'constraints/project_platform.dart';

typedef PlatformWithInfo = (ProjectPlatform, PlatformInfo?);
typedef PackageInfo = ({
  Pubspec pubspec,
  Iterable<PlatformWithInfo> platforms,
});

typedef MigrationDescription = ({Version current, Version target});

typedef PlatformInfoGatherer<T extends PlatformInfo> = Future<T?> Function(
  Directory root,
);
