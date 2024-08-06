import '../constants.dart';
import '../constraints/version_type.dart';

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
          'Either set a specific version with -v <version>, or specify a version type to lift:\n'
          'It must be one of: ${VersionType.values.map((e) => e.name).join(', ')}',
        );
}

class NoIosConfigurationError extends VersionLifterError {
  NoIosConfigurationError()
      : super('The iOS build configuration of this project is not supported');
}
