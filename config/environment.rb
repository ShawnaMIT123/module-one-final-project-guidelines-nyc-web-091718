require 'bundler'
Bundler.require
Dotenv.load

# require 'rake'
# require 'active_record'
# require 'yaml/store'
# require 'ostruct'
# require 'date'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'

ActiveRecord::Base.logger = nil
