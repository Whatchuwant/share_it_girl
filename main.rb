require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'
require 'bcrypt'
enable :sessions


set :database, "sqlite3:funtimes.sqlite3"
set :sessions, true
use Rack::Flash, sweep: true

############# Sign-up and thank you ####################
get '/' do
   @users = User.all 
   erb :home
end

get '/signup' do
	erb :signup
end

post '/signup' do
	@user = User.create(username: params[:username], email: params[:email], password: params[:password])
	session[:user_id] = @user.id
	redirect to '/thanks'
	puts "thanks for joining!"
end

get '/thanks' do
	erb :thanks
end

########### http POST method and '/login' actionroute ###########
get '/login' do
	erb :login
end

post '/login' do
	@user = User.where(email: params[:email]).first

	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:info] = "You're now signed in"
		redirect "/posts"

	else
		flash[:alert] = "Your password or email is incorrect"
		redirect "/login"
	end
end

get '/profile' do
	erb :profile
end

post '/posts' do
	@post = Post.create(body: params[:body])
	# @posts = Post.where(user_id: session[:user_id])
	erb :profile
end

get '/posts' do
	@posts = Post.where(user_id: session[:user_id])
	erb :posts
end

