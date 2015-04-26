require 'sinatra'
require './init'

configure do
  enable :sessions
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

# list routes

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
  if params[:name].length >= 50
    item.item = params[:name][0..48]
  else
    item.item = params[:name]
  end
  item.added_on = Time.now
  if params[:note].length >= 50
    item.note = params[:note][0..48]
  else
    item.note = params[:note]
  end
  item.quantity = params[:quantity]
  item.save
  redirect to('/list')
end

get '/list/:id' do
  redirect to('four_oh_one') unless session[:admin]
  redirect to('/list')
end

get '/:id/list/destroy' do
  redirect to('/four_oh_one') unless session[:admin]
  List.get(params[:id]).destroy
  redirect to('/list')
end

get '/edit/:id' do
  redirect to('/four_oh_one') unless session[:admin]
  @item = List.get(params[:id])
  erb :edit_item, :locals => {'current' => '/list'}
end

post '/edit/:id' do
  item = List.get(params[:id])
  if params[:name].length >= 50
    item.item = params[:name][0..48]
  else
    item.item = params[:name]
  end
  if params[:note].length >= 50
    item.note = params[:note][0..48]
  else
    item.note = params[:note]
  end
  item.save
  redirect to('/list')
end

# authentication routes

get '/signin' do
  erb :signin, :locals => {'current' => '/signin'}
end

post '/signin' do
  name, pw = params[:username], params[:password]
  if User.first(:username => name) && User.first(:username => name).password == pw
    session[:admin] = true
    redirect to('/list')
  else
    erb :four_oh_one
  end
end

get '/signout' do
  session.clear
  redirect to('/')
end
