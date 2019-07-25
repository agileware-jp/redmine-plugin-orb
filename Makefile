.PHONY: all
all: src/executors/ruby-sqlite3.yml src/executors/ruby-26-pg.yml src/executors/ruby-26-mysql.yml;

src/executors/ruby-%-pg.yml: gen_executors_pg.rb
		ruby gen_executors_pg.rb

src/executors/ruby-%-mysql.yml: gen_executors_mysql.rb
		ruby gen_executors_mysql.rb

src/executors/ruby-mysql.yml src/executors/ruby-pg.yml src/executors/ruby-sqlite3.yml: gen_executors_latest.rb
		ruby gen_executors_latest.rb

.PHONY: clean
clean:
		rm src/executors/ruby-*.yml
