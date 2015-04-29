require './main'

# basic routes

get '/' do
  erb :index, :locals => {'current' => '/'}
end

get '/four_oh_one' do
  erb :four_oh_one, :locals => {'current' => '/four_oh_one'}
end

not_found do
  erb :four_oh_four, :locals => {'current' => '/four_oh_four'}
end

# authentication routes

get '/signin' do
  redirect to('/list') if session[:user]
  erb :signin, :locals => {'current' => '/signin'}
end

post '/signin' do
  name, pw = params[:username], params[:password]
  if User.first(:username => name) && User.first(:username => name).password == pw
    if params[:species] == "cat"
      session[:species] = "cat"
      redirect to('/cat')
    else
      session[:species] = "human"
      session[:user] = params[:username]
      redirect to('/')
    end
  else
    erb :four_oh_one
  end
end

get '/signout' do
  session.clear
  redirect to('/')
end

# protected routes

get '/about' do
  redirect to('/four_oh_one') unless session[:user]
  erb :about, :locals => {'current' => '/about'}
end

get '/test' do
  redirect to('/four_oh_one') unless session[:user]
  erb :test, :locals => {'current' => '/test'}
end

get '/cat' do
  redirect to('/four_oh_one') unless session[:species] == "cat"
  erb :cat, :locals => {'current' => '/cat'}
end 

# list routes

get '/list' do
  redirect to('/four_oh_one') unless session[:user]
  @list = List.all
  erb :list, :locals => {'current' => '/list'}
end

get '/list/add' do
  redirect to('/four_oh_one') unless session[:user]
  erb :new_item, :locals => {'current' => '/list'} 
end

post '/list/add' do
  redirect to('/four_oh_one') unless session[:user]
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
  redirect to('four_oh_one') unless session[:user]
  redirect to('/list')
end

get '/:id/list/destroy' do
  redirect to('/four_oh_one') unless session[:user]
  List.get(params[:id]).destroy
  redirect to('/list')
end

get '/edit/:id' do
  redirect to('/four_oh_one') unless session[:user]
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

# message routes

get '/messages' do
  redirect to('/four_oh_one') unless session[:user]
  @messages = Post.all
  @comments = Comment.all
  erb :messages, :locals => {'current' => '/messages'}
end

get '/messages/new' do
  redirect to('four_oh_one') unless session[:user]
  erb :new_message, :locals => {'current' => '/messages'}
end

post '/messages/new' do
  redirect to('/four_oh_one') unless session[:user]
  msg = Post.new
  if params[:topic].length >= 50
    msg.topic = params[:topic][0..48]
  else
    msg.topic = params[:topic]
  end
  msg.message = params[:message]
  msg.added_on = Time.now
  msg.latest_comment = Time.now
  msg.author = session[:user]
  msg.save
  redirect to('/messages')
end

get '/messages/:id' do
  redirect to('/four_oh_one') unless session[:user]
  @msg = Post.get(params[:id])
  @comments = Comment.all(:post_id => params[:id])
  erb :message, :locals => {'current' => '/messages'}
end

post '/messages/:id' do
  msg = Post.get(params[:id])
  comment = Comment.new
  comment.message = params[:message]
  comment.author = session[:user]
  comment.added_on = Time.now
  msg.latest_comment = Time.now
  comment.post_id = params[:id]
  comment.save
  redirect to('/messages')
end

get '/:id/messages/destroy' do
  redirect to('/four_oh_one') unless session[:user]
  Comment.all(:post_id => params[:id]).destroy
  Post.get(params[:id]).destroy
  redirect to('/messages')
end
