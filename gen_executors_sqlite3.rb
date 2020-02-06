require 'erb'

VERSION = <<~POSTGRES.freeze
docker:
  - image: circleci/ruby:<%= ruby_version %>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: sqlite3
POSTGRES

template = ERB.new(VERSION)
%w[2.6 2.5 2.4 2.3 2.2 2.1 2.0 1.9].each do |ruby_version|
  File.write("src/executors/ruby-#{ruby_version.sub('.', '')}-sqlite3.yml", template.result(binding))
end
