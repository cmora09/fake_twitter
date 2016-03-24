require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models.rb"
# require "byebug"

set :database, "sqlite3:faketwitter.sqlite3"

enable :sessions

get '/' do 
	@activeusers=User.all
	@user = current_user
	@posts = Post.all.reverse.first(10)
	if @user

		erb :home
	else
	redirect '/signin'
	end	
end

get '/settings' do 
	@user = current_user
	erb :settings
end

post '/settings' do 
	current_user.update_attributes(fname: params[:fname], lname: params[:lname], username: params[:username], password: params[:password], email: params[:email])
	redirect '/'
end

get '/newpost' do
	erb :newpost
end

post '/newpost' do 
	@post = Post.new(body: params[:post][:body], user_id: current_user.id)
	if !@post.save #this saves automatically but also checks if it's not going to save
		flash[:alert] = "Your post is toooo long!"
		redirect '/newpost'
	else
		redirect '/'
	end
end

get '/signin' do 
	@user = User.where(username: params[:username]).first
	erb :signin
end

post '/signin' do 
	@user = User.where(username: params[:username]).first
 	
 	if @user && @user.password == params[:password]
 		session[:user_id] = @user.id
 		flash[:notice] = "Welcome to FakeTwitter!"
 		redirect '/'
 	else
 		flash[:alert] = "Username and Password Invalid. Please try again!"
 		redirect '/signin'
 	end
end

get '/signup' do 
	erb :signup
end

post '/signup' do 
	@user =	User.new(fname: params[:fname],lname: params[:lname],username: params[:username],password: params[:password],email: params[:email])
	if @user.save
		session[:user_id] = @user.id
		redirect '/'
	else
		redirect '/signup'
	end
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/logout' do 
	session.clear
	redirect '/signin'
end

get '/delete' do 
	erb :delete
end

post '/delete' do
	@user = current_user
	@user.destroy
	session.clear
	redirect '/'
end

get '/profile/:id' do
	@users = User.all
	@user = User.find_by(id: params[:id])
	@posts = Post.where(user_id: @user.id)
	erb :profile
end	

get '/deletepost' do 
	@user = current_user
	@posts = Post.where(user_id: current_user.id).reverse
	erb :deletepost
end

post '/deletepost/:id' do 
	@post = Post.find(params[:id])
	@post.destroy
	redirect '/'
end
