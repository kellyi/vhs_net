require 'sinatra'
require './routes'
require 'redcarpet'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'bcrypt'
require './models'

configure do
  enable :sessions
end

# helper methods

def format_time(t)
  t.strftime("%-m/%-d/%Y %k:%M")
end

def update_login_time
  LoggedIn.create(:name => session[:user], :login_time => Time.now) unless LoggedIn.first(:name => session[:user])
  w = LoggedIn.all.first(:name => session[:user])
  w.login_time = Time.now; w.save
end