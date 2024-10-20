import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import '../../domain/constants.dart';

Future<void> liftPubspecVersion({
  required Directory root,
  required Version currentVersion,
  required Version nextVersion,
}) async {
  final pubspecFile = File.fromUri(root.uri.resolve(pubspecFileName));
  final pubspecStr = await pubspecFile.readAsString();
  // replace the exact entries of the version with the new version
  final newContent = pubspecStr.replaceAll(
    RegExp(r'version:\s*' + RegExp.escape(currentVersion.toString())),
    'version: ${nextVersion.canonicalizedVersion}',
  );

  await pubspecFile.writeAsString(newContent);
}
