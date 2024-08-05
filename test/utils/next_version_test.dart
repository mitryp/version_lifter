import 'dart:math';

import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:version_lifter/src/application/utils/next_version_by_type.dart';
import 'package:version_lifter/src/application/utils/version_ext.dart';
import 'package:version_lifter/src/domain/constraints/version_type.dart';

const _buildSeparator = '.';

void main() {
  final rand = Random();

  group(
    'NextVersionByType tests',
    () {
      late Version initialVersion;
      setUp(() => initialVersion = _randomVersion(rand, pre: true, build: true));

      test(
        'Patch version is lifted correctly',
        () {
          final nextVersion = initialVersion.nextByType(
            type: VersionType.patch,
            keepPre: false,
            keepBuild: false,
          );

          expect(nextVersion, equals(initialVersion.nextPatch));
        },
      );

      test(
        'Minor version is lifted correctly',
        () {
          final nextVersion = initialVersion.nextByType(
            type: VersionType.minor,
            keepPre: false,
            keepBuild: false,
          );

          expect(nextVersion, equals(initialVersion.nextMinor));
        },
      );

      test(
        'Major version is lifted correctly',
        () {
          final nextVersion = initialVersion.nextByType(
            type: VersionType.minor,
            keepPre: false,
            keepBuild: false,
          );

          expect(nextVersion, equals(initialVersion.nextMinor));
        },
      );

      test(
        'Build number is kept when required',
        () {
          final nextVersion = initialVersion.nextByType(type: _randomType(rand), keepBuild: true);

          expect(nextVersion.build, orderedEquals(initialVersion.build));
        },
      );

      test(
        'Pre version is kept when required',
        () {
          final nextVersion = initialVersion.nextByType(type: _randomType(rand), keepPre: true);

          expect(nextVersion.preRelease, orderedEquals(initialVersion.preRelease));
        },
      );

      test(
        'Build number is overridden correctly',
        () {
          final nextBuild = '${rand.nextInt(100) + 50}';
          final nextVersion = initialVersion.nextByType(type: _randomType(rand), build: nextBuild);

          expect(nextVersion.build.join(_buildSeparator), equals(nextBuild));
        },
      );

      test(
        'Pre version is overridden correctly',
        () {
          final nextPre = '${rand.nextInt(100) + 50}';
          final nextVersion = initialVersion.nextByType(type: _randomType(rand), pre: nextPre);

          expect(nextVersion.preRelease.join(_buildSeparator), equals(nextPre));
        },
      );

      test(
        'Build number is incremented correctly for integer build numbers',
        () {
          final nextVersion = initialVersion.nextByType(
            type: _randomType(rand),
            incrementBuild: true,
          );

          expect(
            int.parse(nextVersion.buildStr!),
            equals(int.parse(initialVersion.buildStr!) + 1),
          );
        },
      );

      test(
        'Build number is incremented correctly for composite build strings',
        () {
          final buildNumber = 2;
          initialVersion = initialVersion.copyWith(build: 'dev.3.$buildNumber');
          final nextVersion = initialVersion.nextByType(
            type: _randomType(rand),
            incrementBuild: true,
          );

          expect(
            nextVersion.buildStr,
            equals('dev.3.${buildNumber + 1}'),
          );
        },
      );
    },
  );
}

Version _randomVersion(
  Random rand, {
  bool pre = false,
  bool build = false,
}) =>
    Version(
      rand.nextInt(5),
      rand.nextInt(5),
      rand.nextInt(5),
      pre: pre ? '${rand.nextInt(10)}' : null,
      build: build ? '${rand.nextInt(10)}' : null,
    );

VersionType _randomType(Random rand) => VersionType.values[rand.nextInt(VersionType.values.length)];
