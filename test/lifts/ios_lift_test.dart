import 'package:pub_semver/pub_semver.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:version_lifter/src/application/platform/ios/ios_platform_lifter.dart';
import 'package:version_lifter/src/application/utils/version_ext.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../test_environment.dart';

void main() {
  group(
    'iOS platform lift tests',
    () {
      test(
        'iOS version is set to the specified value',
        () async {
          final targetVersion = Version.parse('7.1.2-5+3');
          final info = await withTestEnvironment(
            platforms: {ProjectPlatform.ios},
            (projectDir) async {
              const lifter = IosPlatformLifter();
              await lifter.lift(projectDir, (current: Version.none, target: targetVersion));

              return lifter.gatherInfo(projectDir);
            },
          );

          expect(info.marketingVersion, equals(targetVersion.marketingVersion));
          expect('${info.projectVersion}', equals(targetVersion.buildStr));
        },
      );

      test(
        'iOS project version is not changed when no build is specified in the target version',
        () async {
          final targetVersion = Version.parse('7.1.2');
          final info = await withTestEnvironment(
            platforms: {ProjectPlatform.ios},
            (projectDir) async {
              const lifter = IosPlatformLifter();
              await lifter.lift(projectDir, (current: Version.none, target: targetVersion));

              return lifter.gatherInfo(projectDir);
            },
          );

          expect(info.marketingVersion, equals(targetVersion.marketingVersion));
          expect(info.projectVersion, equals(1));
        },
      );
    },
  );
}
