import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:version_lifter/src/domain/constants.dart';
import 'package:version_lifter/src/domain/errors/version_lifter_error.dart';

Future<Pubspec> parsePubspec(Directory root) async {
  final file = File.fromUri(root.uri.resolve(pubspecFileName));

  if (await file.exists()) {
    return file.readAsString().then(Pubspec.parse);
  }

  throw NotAPackageError();
}