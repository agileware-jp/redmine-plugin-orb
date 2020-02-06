require 'erb'

VERSION = <<~MARIADB.freeze
parameters:
  mariadb_version:
    description: version of MariaDB
    type: string
    default: <%= mariadb_version %>
docker:
  - image: circleci/ruby:<%= ruby_version %>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: mysql2
  - image: circleci/mariadb:<< parameters.mariadb_version >>
MARIADB

template = ERB.new(VERSION)
{
  'latest-ram': %w[2.6 2.5],
  '10.3-ram': %w[2.4 2.3 2.2 2.1 2.0 1.9]
}.each do |mariadb_version, ruby_versions|
  ruby_versions.each do |ruby_version|
    File.write("src/executors/ruby-#{ruby_version.sub('.', '')}-mariadb.yml", template.result(binding))
  end
end
