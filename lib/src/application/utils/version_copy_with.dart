import 'package:pub_semver/pub_semver.dart';

extension VersionCopyWith on Version {
  static const separator = '.';

  Version copyWith({
    int? major,
    int? minor,
    int? patch,
    String? build,
    String? pre,
  }) {
    final currentBuild = this.build.isEmpty ? null : this.build.join(separator);
    final currentPre = preRelease.isEmpty ? null : preRelease.join(separator);

    return Version(
      major ?? this.major,
      minor ?? this.minor,
      patch ?? this.patch,
      build: build ?? currentBuild,
      pre: pre ?? currentPre,
    );
  }
}
