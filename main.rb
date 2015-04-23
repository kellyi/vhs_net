require 'sinatra'
require 'yaml'

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

get '/contact' do
  erb :contact, :locals => {'current' => '/contact'}
end

get '/four_oh_one' do
  erb :four_oh_one, :locals => {'current' => '/four_oh_one'}
end

not_found do
  erb :four_oh_four, :locals => {'current' => '/four_oh_four'}
end

# protected route

get '/test' do
  redirect to('/four_oh_one') unless session[:admin]
  erb :test, :locals => {'current' => '/test'}
end

# authentication routes

get '/signin' do
  erb :signin, :locals => {'current' => '/signin'}
end

post '/signin' do
  name, pw = params[:username], params[:password]
  if settings.username.include?(name) && pw == settings.password[settings.username.index(name)]
    session[:admin] = true
    redirect to('/test')
  else
    erb :signin
  end
end

get '/signout' do
  session.clear
  redirect to('/')
end
