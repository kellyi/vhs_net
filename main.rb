require 'sinatra'

get '/' do
  erb :index, :locals => {'current' => '/'}
end

get '/signin' do
  erb :signin, :locals => {'current' => '/signin'}
end

get '/about' do
  erb :about, :locals => {'current' => '/about'}
end

get '/contact' do
  erb :contact, :locals => {'current' => '/contact'}
end

get '/test' do
  erb :test, :locals => {'current' => '/test'}
end

not_found do
  erb :four_oh_four, :locals => {'current' => '/four_oh_four'}
end
