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
