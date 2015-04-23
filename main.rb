require 'sinatra'
require 'yaml'
require './list'

configure do
  enable :sessions
  credentials = YAML.load_file('./auth.yml')
  set :username, credentials[:usernames]
  set :password, credentials[:passwords]
end

# basic routes

get '/' do
  erb :index, :locals => {'current' => '/'}
end

get '/about' do
  erb :about, :locals => {'current' => '/about'}
end

get '/four_oh_one' do
  erb :four_oh_one, :locals => {'current' => '/four_oh_one'}
end

not_found do
  erb :four_oh_four, :locals => {'current' => '/four_oh_four'}
end

# protected routes

get '/test' do
  redirect to('/four_oh_one') unless session[:admin]
  erb :test, :locals => {'current' => '/test'}
end

get '/list' do
  redirect to('/four_oh_one') unless session[:admin]
  @list = List.all
  erb :list, :locals => {'current' => '/list'}
end

get '/list/add' do
  redirect to('/four_oh_one') unless session[:admin]
  erb :new_item, :locals => {'current' => '/list'} 
end

post '/list/add' do
  redirect to('/four_oh_one') unless session[:admin]
  item = List.new
  item.item = params[:name]
  item.added_on = Time.now
  item.note = params[:notes]
  item.quantity = params[:quantity]
  item.save
  redirect to('/list')
end

get '/list/:id' do
  redirect to('/four_oh_one') unless session[:admin]
  List.get(params[:id]).destroy
  redirect to('/list')
end

# authentication routes

get '/signin' do
  erb :signin, :locals => {'current' => '/signin'}
end

post '/signin' do
  name, pw = params[:username], params[:password]
  if settings.username.include?(name) && pw == settings.password[settings.username.index(name)]
    session[:admin] = true
    redirect to('/list')
  else
    erb :signin
  end
end

get '/signout' do
  session.clear
  redirect to('/')
end
