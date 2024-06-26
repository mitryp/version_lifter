import 'package:pub_semver/pub_semver.dart';

import '../../domain/constraints/version_type.dart';
import '../utils/version_copy_with.dart';

extension NextVersionByType on Version {
  Version nextByType({
    required VersionType type,
    String? build,
    String? pre,
    bool keepBuild = false,
    bool keepPre = false,
  }) {
    final nextCleanVersion = switch (type) {
      VersionType.patch => nextPatch,
      VersionType.minor => nextMinor,
      VersionType.major => nextMajor,
    };

    final newBuild = build ?? this.build.join(VersionCopyWith.separator);
    final newPre = pre ?? preRelease.join(VersionCopyWith.separator);

    return nextCleanVersion.copyWith(
      build: keepBuild ? newBuild : null,
      pre: keepPre ? newPre : null,
    );
  }
}
