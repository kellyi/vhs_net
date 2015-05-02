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
      LoggedIn.create(:name => name, :login_time => Time.now) unless LoggedIn.first(:name => name)
      redirect to('/cat')
    else
      session[:species] = "human"
      session[:user] = params[:username]
      LoggedIn.create(:name => name, :login_time => Time.now) unless LoggedIn.first(:name => name)
      redirect to('/')
    end
  else
    erb :four_oh_one
  end
end

get '/signout' do
  LoggedIn.all(:name => session[:user]).destroy
  session.clear
  redirect to('/')
end

# protected routes

get '/about' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  erb :about, :locals => {'current' => '/about'}
end

get '/test' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  erb :test, :locals => {'current' => '/test', 'user' => session[:user]}
end

get '/cat' do
  redirect to('/four_oh_one') unless session[:species] == "cat"
  update_login_time
  erb :cat, :locals => {'current' => '/cat'}
end 

get '/who' do
  redirect to('/four_oh_one') unless session[:user] 
  update_login_time
  LoggedIn.all.each { |w| w.destroy if Time.now - 600 > w.login_time }
  @who = LoggedIn.all
  erb :who, :locals => {'current' => '/who'}
end

# list routes

get '/list' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @list = List.all(:order => [:id.desc])
  erb :list, :locals => {'current' => '/list'}
end

get '/list/add' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  erb :new_item, :locals => {'current' => '/list'} 
end

post '/list/add' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
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
  update_login_time
  redirect to('/list')
end

get '/:id/list/destroy' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  List.get(params[:id]).destroy
  redirect to('/list')
end

get '/edit/:id' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @item = List.get(params[:id])
  erb :edit_item, :locals => {'current' => '/list'}
end

post '/edit/:id' do
  item = List.get(params[:id])
  update_login_time
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
  update_login_time
  @messages = Post.all(:order => [:id.desc])
  @comments = Comment.all
  erb :messages, :locals => {'current' => '/messages'}
end

get '/messages/new' do
  redirect to('four_oh_one') unless session[:user]
  update_login_time
  erb :new_message, :locals => {'current' => '/messages'}
end

post '/messages/new' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
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
  update_login_time
  @msg = Post.get(params[:id])
  @comments = Comment.all(:post_id => params[:id])
  erb :message, :locals => {'current' => '/messages'}
end

post '/messages/:id' do
  update_login_time
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
  update_login_time
  Comment.all(:post_id => params[:id]).destroy
  Post.get(params[:id]).destroy
  redirect to('/messages')
end

# polls

get '/polls' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @polls = Poll.all(:order => [:id.desc])
  erb :polls, :locals => {'current' => '/polls'}
end

get '/polls/new' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  erb :new_poll, :locals => {'current' => '/polls'}
end

post '/polls/new' do
  update_login_time
  p = Poll.new
  p.question = params[:question]
  p.added_on = Time.now
  p.added_by = session[:user]
  p.yeas = 0
  p.nays = 0
  p.save
  redirect to('/polls')
end

get '/:id/polls/destroy' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  Poll.get(params[:id]).destroy
  redirect to('/polls')
end

get '/poll/:id' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @poll = Poll.get(params[:id])
  erb :poll, :locals => {'current' => '/polls'}
end

post '/poll/:id' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  p = Poll.get(params[:id])
  if params[:yea]
    p.yeas += 1
  elsif params[:nay]
    p.nays += 1
  end
  p.save
  redirect to('/polls')
end

# private mail

get '/mail/received' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @mail = Mail.all(:recipient => session[:user])
  @mail = @mail.all(:order => [:id.desc])
  erb :mail, :locals => {'current' => '/mail'}  
end

get '/mail/sent' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @mail = Mail.all(:sender => session[:user])
  @mail = @mail.all(:order => [:id.desc])
  erb :sent_mail, :locals => {'current' => '/mail'}  
end

get '/mail/new' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  erb :new_mail, :locals => {'current' => '/mail'}
end

post '/mail/new' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  m = Mail.new
  m.subject = params[:subject]
  m.recipient = params[:recipient]
  m.sender = session[:user]
  m.sent_at = Time.now
  m.text = params[:text]
  m.save
  redirect to('/mail/received')
end

get '/mail/:id' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  @mail = Mail.get(params[:id])
  redirect to('/four_oh_four') unless @mail.recipient == session[:user]
  erb :read_mail, :locals => {'current' => '/mail'}
end

post '/mail/:id' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  original_mail = Mail.get(params[:id])
  m = Mail.new
  m.subject = params[:subject]
  m.sender = session[:user]
  m.recipient = original_mail.sender
  m.sent_at = Time.now
  m.text = params[:text]
  m.save
  redirect to('/mail/received')
end

get '/:id/mail/destroy' do
  redirect to('/four_oh_one') unless session[:user]
  update_login_time
  Mail.get(params[:id]).destroy
  redirect to('/mail/received')
end
