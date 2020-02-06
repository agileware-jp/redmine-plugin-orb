require 'erb'

VERSION = <<~MYSQL.freeze
parameters:
  mysql_version:
    description: version of MySQL
    type: string
    default: <%= mysql_version %>
docker:
  - image: circleci/ruby:<%= ruby_version %>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: mysql2
  - image: circleci/mysql:<< parameters.mysql_version >>
    command: mysqld --default-authentication-plugin=mysql_native_password
MYSQL

template = ERB.new(VERSION)
{
  'latest-ram': %w[2.6 2.5],
  '5-ram': %w[2.4 2.3 2.2 2.1 2.0 1.9]
}.each do |mysql_version, ruby_versions|
  ruby_versions.each do |ruby_version|
    File.write("src/executors/ruby-#{ruby_version.sub('.', '')}-mysql.yml", template.result(binding))
  end
end
