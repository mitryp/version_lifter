import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:version_lifter/src/application/info/parse_pubspec.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../test_environment.dart';

void main() {
  group(
    'Pubspec parse tests',
    () {
      test(
        'Pubspec is parsed correctly',
        () async {
          const name = 'pubspec_parse_test';
          final pubspec = await withTestEnvironment(
            (projectDir) => parsePubspec(projectDir),
            platforms: {ProjectPlatform.android},
            name: name,
          );

          expect(pubspec.name, name);
          expect(pubspec.version, equals(initialProjectVersion));
        },
      );
    },
  );
}
