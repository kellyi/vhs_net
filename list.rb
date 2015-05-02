require './main'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class List
  include DataMapper::Resource
  property :id, Serial
  property :item, String
  property :note, String
  property :quantity, Integer
  property :added_on, Time
end

DataMapper.finalize
DataMapper.auto_upgrade!
