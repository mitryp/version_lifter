import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:version_lifter/src/application/info/parse_pubspec.dart';
import 'package:version_lifter/src/application/lift/lift_pubspec_version.dart';

import '../test_environment.dart';

void main() {
  group(
    'Pubspec version lifting tests',
    () {
      test(
        'Pubspec version is overridden correctly',
        () async {
          final nextVersion = initialProjectVersion.nextBreaking;

          final newVersion = await withTestEnvironment(
            platforms: {},
            (projectDir) async {
              await liftPubspecVersion(
                root: projectDir,
                currentVersion: initialProjectVersion,
                nextVersion: nextVersion,
              );

              return parsePubspec(projectDir)
                  .then((pubspec) => pubspec.version);
            },
          );

          expect(newVersion, equals(nextVersion));
        },
      );
    },
  );
}
