## Task Module

Provides a `task` command which is a thin wrapper around the `task` binary from [taskfile.dev].

The wrapper sets the environment variable `TASKFILE` to a generated YAML file and passes it via the `--taskfile` flag
to the underlying command.

[taskfile.dev]: https://taskfile.dev
