import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:version_lifter/src/domain/constants.dart';

Future<void> liftPubspecVersion({
  required Directory root,
  required Version currentVersion,
  required Version nextVersion,
}) async {
  final pubspecFile = File.fromUri(root.uri.resolve(pubspecFileName));
  final pubspecStr = await pubspecFile.readAsString();

  // replace the exact entries of the version with the new version
  final newContent = pubspecStr.replaceAll(
    currentVersion.toString(),
    nextVersion.canonicalizedVersion,
  );

  await pubspecFile.writeAsString(newContent);
}
