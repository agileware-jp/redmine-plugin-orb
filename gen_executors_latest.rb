File.write('src/executors/ruby-pg.yml', <<~POSTGRES.freeze)
parameters:
  ruby_version:
    description: version of Ruby
    type: string
    default: latest
  pg_version:
    description: version of PostgreSQL
    type: string
    default: latest-ram
docker:
  - image: circleci/ruby:<< parameters.ruby_version >>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: postgresql
  - image: circleci/postgres:<< parameters.pg_version >>
    environment:
      POSTGRES_PASSWORD: password
POSTGRES

File.write('src/executors/ruby-mariadb.yml', <<~MARIADB.freeze)
parameters:
  ruby_version:
    description: version of Ruby
    type: string
    default: latest
  mariadb_version:
    description: version of MariaDB
    type: string
    default: latest-ram
docker:
  - image: circleci/ruby:<< parameters.ruby_version >>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: mysql2
  - image: circleci/mariadb:<< parameters.mariadb_version >>
MARIADB

File.write('src/executors/ruby-mysql.yml', <<~MYSQL.freeze)
parameters:
  ruby_version:
    description: version of Ruby
    type: string
    default: latest
  mysql_version:
    description: version of MySQL
    type: string
    default: latest-ram
docker:
  - image: circleci/ruby:<< parameters.ruby_version >>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: mysql2
  - image: circleci/mysql:<< parameters.mysql_version >>
    command: mysqld --default-authentication-plugin=mysql_native_password
MYSQL

File.write('src/executors/ruby-sqlite3.yml', <<~SQLITE3.freeze)
parameters:
  ruby_version:
    description: version of Ruby
    type: string
    default: latest
docker:
  - image: circleci/ruby:<< parameters.ruby_version >>-node-browsers
    environment:
      RAILS_ENV: test
      DATABASE_ADAPTER: sqlite3
SQLITE3
