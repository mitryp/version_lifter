import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:version_lifter/src/application/utils/version_ext.dart';

void main() {
  group('VersionExt tests', () {
    test(
      'Version.buildStr is formatted correctly',
      () {
        expect(Version.parse('1.2.3+45').buildStr, equals('45'));
        expect(Version.parse('1.2.3+dev.5').buildStr, equals('dev.5'));
      },
    );

    test(
      'Version.marketingVersion is formatted correctly',
      () {
        expect(Version.parse('1.2.3+45').marketingVersion, equals('1.2.3'));
        expect(
          Version.parse('0.12.1+dev.5').marketingVersion,
          equals('0.12.1'),
        );
      },
    );

    test(
      'Version.nextBuild is calculated correctly',
      () {
        expect(Version.parse('1.2.3').nextBuild, isNull);
        expect(Version.parse('1.2.3+45').nextBuild, equals('46'));
        expect(Version.parse('0.12.1+dev.5').nextBuild, equals('dev.6'));
      },
    );

    test(
      'Version.copyWith works correctly',
      () {
        final version = Version(1, 2, 3, build: 'dev.45', pre: 'pre.3');

        expect(version.copyWith(), equals(version));
        expect(version.copyWith(major: 20).major, equals(20));
        expect(version.copyWith(minor: 7).minor, equals(7));
        expect(version.copyWith(patch: 150).patch, equals(150));
        expect(
          version.copyWith(build: 'strBuild').build,
          orderedEquals(['strBuild']),
        );
        expect(
          version.copyWith(pre: 'strPre').preRelease,
          orderedEquals(['strPre']),
        );
        expect(
          version.copyWith(
            major: 20,
            minor: 7,
            patch: 150,
            build: 'dev.17',
            pre: 'pre.5',
          ),
          equals(Version.parse('20.7.150-pre.5+dev.17')),
        );
      },
    );
  });
}
