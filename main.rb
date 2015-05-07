require 'sinatra'
require 'redcarpet'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'bcrypt'
require 'sanitize'
require './models'
require './routes'

configure do
  enable :sessions
end

# helper methods

def format_time(t)
  t.strftime("%-m/%-d/%Y %k:%M")
end

def login
  LoggedIn.create(:name => session[:user], :login_time => Time.now)
end

def update_login_time
  login unless LoggedIn.first(:name => session[:user])
  w = LoggedIn.all.first(:name => session[:user])
  w.login_time = Time.now; w.save
end

def fourohone
  redirect to('/four_oh_one') unless session[:user]
end
