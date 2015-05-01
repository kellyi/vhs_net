require './main'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class User
  include DataMapper::Resource
  include BCrypt
  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash
end

class LoggedIn
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :login_time, Time
end

DataMapper.finalize
DataMapper.auto_upgrade!
