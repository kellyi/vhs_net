require 'sinatra'
require './routes'
require 'redcarpet'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'bcrypt'
require './main'
require './list'
require './user'
require './post'

configure do
  enable :sessions
end
