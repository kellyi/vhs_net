require './main'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Post
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :topic, String
  property :message, Text
  property :author, String
  property :added_on, Time
  property :latest_comment, Time

  has n, :comments
end

class Comment
  include DataMapper::Resource

  property :id, Serial
  property :message, Text
  property :author, String
  property :added_on, Time

  belongs_to :post 

end

DataMapper.finalize
DataMapper.auto_upgrade!
