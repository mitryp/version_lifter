import 'package:pub_semver/pub_semver.dart';

import '../../domain/constraints/version_type.dart';
import 'version_ext.dart';

extension NextVersionByType on Version {
  Version nextByType({
    required VersionType type,
    String? build,
    String? pre,
    bool keepBuild = true,
    bool incrementBuild = false,
    bool keepPre = false,
  }) {
    final nextCleanVersion = switch (type) {
      VersionType.patch => nextPatch,
      VersionType.minor => nextMinor,
      VersionType.major => nextMajor,
    };

    final newBuild = build ?? (incrementBuild ? nextBuild : buildStr);
    final newPre = pre ?? preRelease.join(VersionExt.separator);

    return nextCleanVersion.copyWith(
      build: keepBuild ? newBuild : null,
      pre: pre != null || keepPre ? newPre : null,
    );
  }
}
