require 'sinatra'

get '/' do
  erb :index
end

get 'not found' do
  erb :index
end

