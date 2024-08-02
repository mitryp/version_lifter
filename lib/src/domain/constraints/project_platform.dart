enum ProjectPlatform {
  android,
  ios(
    postLiftCommandFlag: 'post-ios',
    postLiftCommandHelp: 'A command to run after iOS has been lifted. '
        'For Flutter, consider "flutter build ios --config-only"',
  ),
  web,
  windows,
  linux;

  final String? postLiftCommandFlag;
  final String? postLiftCommandHelp;

  const ProjectPlatform({this.postLiftCommandFlag, this.postLiftCommandHelp});

  static final Map<String, ProjectPlatform> namesToPlatforms = Map.fromEntries(
    values.map((platform) => MapEntry(platform.name, platform)),
  );
}
