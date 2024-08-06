import 'package:test/test.dart';
import 'package:version_lifter/src/application/common/detect_platforms.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../test_environment.dart';

void main() {
  group(
    'Platform detection tests',
    () {
      test(
        'All platforms are detected in a project with all platforms',
        () async {
          final platforms = ProjectPlatform.values.toSet();

          final actual = await withTestEnvironment(
            (projectDir) => detectPlatforms(projectDir),
            platforms: platforms,
          );

          expect(actual, unorderedEquals(platforms));
        },
      );

      test(
        'A specific platform set is detected correctly',
        () async {
          final platforms = {
            ProjectPlatform.android,
            ProjectPlatform.ios,
            ProjectPlatform.web,
          };

          final actual = await withTestEnvironment(
            (projectDir) => detectPlatforms(projectDir),
            platforms: platforms,
          );

          expect(actual, unorderedEquals(platforms));
        },
      );
    },
  );
}
