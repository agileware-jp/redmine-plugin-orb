require 'erb'

VERSION = <<~POSTGRES.freeze
parameters:
  pg_version:
    description: version of PostgreSQL
    type: string
    default: <%= pg_version == :'latest-ram' ? 'latest-ram' : "'" + pg_version.to_s + "'" %>
docker:
  - image: circleci/ruby:<%= ruby_version %>-node-browsers
    environment:
      DATABASE_ADAPTER: postgresql
  - image: circleci/postgres:<< parameters.pg_version >>
POSTGRES

template = ERB.new(VERSION)
{
  'latest-ram': %w[2.6 2.5],
  '9-ram': %w[2.4 2.3 2.2 2.1 2.0 1.9]
}.each do |pg_version, ruby_versions|
  ruby_versions.each do |ruby_version|
    File.write("src/executors/ruby-#{ruby_version.sub('.', '')}-pg.yml", template.result(binding))
  end
end
