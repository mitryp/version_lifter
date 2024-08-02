import '../../../domain/abs/platform_info.dart';

final class IosInfo extends PlatformInfo {
  final String marketingVersion;
  final int projectVersion;

  const IosInfo({
    required this.marketingVersion,
    required this.projectVersion,
  });

  @override
  String toString() => '$marketingVersion ($projectVersion)';
}
