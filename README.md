# Redmine Plugin Orb 2.3.0

## SCM preparation for plugin tests

The `rspec` and `test` commands prepare Git and Subversion after database setup.
Missing clients are installed, both adapters are enabled in the test database,
and their availability is checked through Redmine's real `Setting.enabled_scm`.
No application methods are stubbed.

The `setup-scm` command adds missing SCM path regular expressions only to the
`test` section of `config/configuration.yml`. Its defaults allow local repositories
under the temporary directory or Redmine's `tmp` directory, with or without a
`file://` prefix. Existing expressions in `test` or `default` are preserved, as
are other environment settings. ERB configurations are left unchanged and
rejected instead of evaluating templates and persisting environment values.
Configure other repository paths explicitly before running the command.
An existing configuration that disables an adapter will make the
availability check fail instead of silently replacing that configuration.

Set `setup_scm: false` on `rspec` or `test` when testing SCM availability itself
or supplying a different SCM environment. To use `setup-scm` independently,
run it after installing gems and creating/migrating the test database.

## Recording the tested Redmine

The `rspec` command records the Redmine actually used by the job after all
tests (including the migration rollback test) have passed. Because CircleCI
skips the remaining steps of a failed job, the presence of the file means the
job passed. Set `record_tested_redmine: false` on `rspec` to disable it, or run
the `record-tested-redmine` command on its own after the test database is ready.

The record is persisted to the workspace, so downstream jobs collect it with
`attach_workspace` and no CircleCI API access:

```yaml
- attach_workspace:
    at: /tmp/workspace
- run: cat /tmp/workspace/tested-redmine/*.json
```

The contract with downstream jobs consists of three parts.

- The workspace directory `tested-redmine/` is reserved by this orb. Other
  layers persisted by upstream jobs (for example built `assets`) are attached
  alongside it and should be ignored.
- One file per job, named after `CIRCLE_JOB`: characters outside
  `[A-Za-z0-9._-]` are replaced with `-`, consecutive `-` are collapsed, and
  `-<CIRCLE_NODE_INDEX>` is appended when `parallelism` is greater than 1.
  For example `RSpec on supported maximum versions with PostgreSQL` becomes
  `RSpec-on-supported-maximum-versions-with-PostgreSQL.json`.
- The JSON keys below. Keys may be added in a minor release; removing or
  retyping a key requires a major release. Zero files is a valid result
  (failed job, older orb, or recording disabled).

| Key | Type | Source |
|---|---|---|
| `job` | string | `CIRCLE_JOB` as is |
| `redmine_version` | string | `Redmine::VERSION.to_s`, e.g. `6.1.2.stable` |
| `redmine_commit` | string or null | `git rev-parse HEAD` when Redmine was cloned with git, otherwise null |
| `ruby_version` | string | `RUBY_VERSION` |
| `db_adapter` | string | `ActiveRecord::Base.connection.adapter_name`, e.g. `PostgreSQL`, `Mysql2` |
| `plugin` | string | The tested plugin name |
| `recorded_at` | string | ISO 8601 in UTC |

```json
{
  "job": "RSpec on supported maximum versions with PostgreSQL",
  "redmine_version": "6.1.2.stable",
  "redmine_commit": null,
  "ruby_version": "3.4.7",
  "db_adapter": "PostgreSQL",
  "plugin": "alm",
  "recorded_at": "2026-10-19T07:12:40Z"
}
```
