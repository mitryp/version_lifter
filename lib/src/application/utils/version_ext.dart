import 'package:pub_semver/pub_semver.dart';

extension VersionExt on Version {
  static const separator = '.';

  Version copyWith({
    int? major,
    int? minor,
    int? patch,
    String? build,
    String? pre,
  }) {
    final currentBuild = buildStr;
    final currentPre = preRelease.isEmpty ? null : preRelease.join(separator);

    return Version(
      major ?? this.major,
      minor ?? this.minor,
      patch ?? this.patch,
      build: build ?? currentBuild,
      pre: pre ?? currentPre,
    );
  }

  String get marketingVersion {
    final str = toString();
    if (build.isEmpty) {
      return str;
    }

    return str.split('+').first;
  }

  String? get buildStr => build.isEmpty ? null : build.join(separator);

  String? get nextBuild {
    if (build.isEmpty) {
      return null;
    }

    final [...rest, toIncrement] = build;

    if (toIncrement is! int) {
      return buildStr;
    }

    return [...rest, toIncrement + 1].join(separator);
  }
}
