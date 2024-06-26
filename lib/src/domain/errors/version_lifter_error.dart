import 'package:version_lifter/src/domain/constants.dart';
import 'package:version_lifter/src/domain/constraints/version_type.dart';

abstract class VersionLifterError extends Error {
  final String message;

  VersionLifterError(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NotAPackageError extends VersionLifterError {
  NotAPackageError()
      : super('Current directory does not contain a $pubspecFileName');
}

class NoVersionTypeError extends VersionLifterError {
  NoVersionTypeError()
      : super(
          'No version type was specified when running.\n'
          'It must be one of: ${VersionType.values.map((e) => e.name).join(', ')}',
        );
}
