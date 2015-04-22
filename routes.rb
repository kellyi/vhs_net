require_relative 'main.rb'
# application routes
#
#
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

not_found do
  erb :four_oh_four, :locals => {'current' => '/four_oh_four'}
end

# protected routes

get '/test' do
  env['warden'].authenticate!
  erb :test, :locals => {'current' => '/test'}
end

# authentication routes

get '/signup' do
  erb :signup, :locals => {'current' => '/signup'}
end

get '/signin' do
  erb :signin, :locals => {'current' => '/signin'}
end

post '/signin' do
  env['warden'].authenticate!
  flash[:success] = env['warden'].messge || "successfully logged in"
  if session[:return_to].nil?
    redirect to('/')
  else
    redirect session[:return_to]
  end
end

# not sure about this one
post '/auth/unauthenticated' do
  session[:return_to] = env['warden.options'][:attempted_path]
  puts env['warden.options'][:attempted_path]
  flash[:error] = env['warden'].message || 'You must login to continue'
  redirect to ('/auth/login')
end

get '/signout' do
  env['warden'].raw_session.inspect
  env['warden'].logout
  flash[:success] = "successfully logged out!"
  redirect to ('/')
end
