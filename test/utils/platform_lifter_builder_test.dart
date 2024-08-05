import 'package:collection/collection.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:version_lifter/src/application/platform/build_platform_lifter.dart';
import 'package:version_lifter/src/application/platform/ios/ios_platform_lifter.dart';
import 'package:version_lifter/src/application/platform/passing_platform_lifter.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

void main() {
  group(
    'PlatformLifterBuilder tests',
    () {
      test(
        'iOS lifter built is IosPlatformLifter',
        () {
          expect(ProjectPlatform.ios.buildLifter(), isA<IosPlatformLifter>());
        },
      );

      test(
        'Other platforms\' lifters are PassingPlatformLifters',
        () {
          final otherPlatforms = ProjectPlatform.values.whereNot((e) => e == ProjectPlatform.ios);
          final lifters = otherPlatforms.map((e) => e.buildLifter());

          for (final lifter in lifters) {
            expect(lifter, isA<PassingPlatformLifter>());
          }
        },
      );
    },
  );
}
