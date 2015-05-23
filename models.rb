require './main'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

# user signin

class User
  include DataMapper::Resource
  include BCrypt
  property :id, Serial
  property :username, String, :length => 3..50
  property :password, BCryptHash
  property :location, String
  property :description, Text
  property :site, String
end

class LoggedIn
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :login_time, Time
end

# public messages

class Post
  include DataMapper::Resource

  property :id, Serial
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

# private mail

class Mail
  include DataMapper::Resource

  property :id, Serial
  property :subject, String
  property :text, Text
  property :sender, String
  property :recipient, String
  property :sent_at, Time
end

# list

class List
  include DataMapper::Resource
  property :id, Serial
  property :item, String
  property :note, String
  property :quantity, Integer
  property :added_on, Time
  property :added_by, String
end

# polls

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