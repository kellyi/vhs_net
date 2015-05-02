require './main'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Poll
  include DataMapper::Resource
  property :id, Serial
  property :question, Text
  property :yeas, Integer
  property :nays, Integer
  property :added_on, Time
  property :added_by, String
end

DataMapper.finalize
DataMapper.auto_upgrade!
