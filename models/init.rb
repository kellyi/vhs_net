require 'data_mapper'
require 'bcrypt'

DataMapper.setup(:default, 'sqlite::memory:')

require_relative "user"

DataMapper.finalize
DataMapper.auto_upgrade!

if User.count == 0
  @user = User.create(username: "admin")
  @user.password = "admin"
  @user.save
end
