import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

typedef PackageInfo = ({Pubspec pubspec, Set<ProjectPlatform> platforms});

typedef PlatformLifter = Future<void> Function({
  required Version currentVersion,
  required Version nextVersion,
});
