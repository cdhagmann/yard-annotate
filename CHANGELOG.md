# 2.1.0
* Do not add duplicate signatures to methods (@wpride, #15).

# 2.0.0
* Fix emission of `T::Array`, `T::Hash`, and `T.any` types (@wpride, #14).
* BREAKING: Add ability to write RBI output to a file via the `--rbi` flag. `--rbi` used to be a switch, but now it's a flag that accepts either a file path or `-` for STDOUT.

# 1.3.0
* Add `YARN_ANNOTATE_FILES` and `YARN_ANNOTATE_ANNOTATE` environment variables to RSpec helper.

# 1.2.0
* Print example usage and global help if CLI is run with no arguments.

# 1.1.0
* Print log output to STDERR.
* Add global --silent CLI option to quash all YarnAnnotate log output.
* Add `--rbi` flag to `run` subcommand to separate RBI output functionality from file annotation.

# 1.0.2
* Correctly restore Ruby load path after command execution.

# 1.0.1
* Require yarn_annotate/version in yarn-annotate executable (d'oh!)

# 1.0.0
* Birthday!
