# version_lifter CLI Tool

`version_lifter` is a CLI package designed to automate versioning of your Dart applications. It provides convenient
commands to display current package information and to set and increment the package version.

> The package is in its early stage, and it's advised to use git to be able to revert the changes
> made. If you faced any issues, see [Contributing](#Contributing).

## Installation

To install `version_lifter`, use the following command:

```sh
dart pub global activate version_lifter
```

## Usage

The basic syntax for using `version_lifter` is:

```sh
version_lifter <command> [arguments]
```

### Global Options

- `-h`, `--help`: Print usage information.
- `--version`: Print the tool version.

## Available Commands

### `info`

Displays the current package information, including its version and supported platforms.

```sh
version_lifter info [arguments]
```

#### Options

- `-h`, `--help`: Print usage information for the `info` command.

### `lift`

Lifts (increments) the version of the package. This command supports several flags to customize the versioning process.

```sh
version_lifter lift [arguments]
```

#### Options

- `-h`, `--help`: Print usage information for the `lift` command.
- `--[no-]dry-run`: Perform a dry run without making any changes.
- `--[no-]keep-build`: Retain the build number (default: on).
- `--[no-]keep-pre`: Retain the pre-release version.
- `--[no-]increment-build`: Increment the build number (default: on).
- `-b`, `--build`: Set a custom build version.
- `--pre`: Set a custom pre-release version.
- `-v`, `--version`: Set a specific version in SemVer format. If provided, all other flags will be ignored.
- `--post-ios`: Run a command after the iOS version has been lifted. For Flutter,
  consider `flutter build ios --config-only`.
- `--major`: Increment the major version.
- `--minor`: Increment the minor version.
- `--patch`: Increment the patch version.

## Examples

1. **Display package info:**

    ```sh
    version_lifter info
    ```

2. **Lift version of the specified type:**

    ```sh
    version_lifter lift --<type>
    ```

   Where \<type> is one of `patch`, `minor`, or `major`.

3. **Set a specific version:**

    ```sh
    version_lifter lift --version <version>
    ```

   Where \<version> is a valid version in a SemVer format: 1.0.1, 2.1.0+3, 0.12.3-pre.1+dev.5

4. **Set a custom pre-release and build versions:**

    ```sh
    --pre <preRelease version> --build <build number>
    ```

5. **Increment the minor version and specify a build number:**

    ```sh
    version_lifter lift --minor --build 123
    ```

## Help

For detailed information about a specific command, use:

```sh
version_lifter help <command>
```

For general help, use:

```sh
version_lifter --help
```

---

`version_lifter` is a powerful tool that allows you to manage your Dart app versions effortlessly. With its flexible
options and easy-to-use commands, you can maintain consistent and accurate versioning in your projects.

## Contributing

Feel free to [open an issue](https://github.com/mitryp/version_lifter/issues) whenever you face a problem caused by this
library. PRs are also most welcome!
