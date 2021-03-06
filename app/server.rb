require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative 'data_mapper_setup'
require_relative 'helpers/session'


enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
include SessionHelpers

	get '/' do 
		@links = Link.all
		erb :index
	end

	post '/links' do
		url = params[:url]
		title = params[:title]
		tags = params[:tags].split(' ').map {|tag| Tag.first_or_create(:text => tag)}
		Link.create(:url => url, :title => title, :tags => tags)
		redirect to('/')
	end

	get '/tags/:text' do
		tag = Tag.first(:text => params[:text])
		@links = tag ? tag.links : []
		erb :index
	end

	get '/users/new' do 
		@user = User.new
		erb :"users/new"
	end

	post '/users' do 
		@user = User.create(:email => params[:email],
			:password => params[:password],
			:password_confirmation => params[:password_confirmation])
		
		if @user.save
			session[:user_id] = @user.id
			redirect to('/')
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	get '/sessions/new' do 
		erb :"sessions/new"
	end

	post '/sessions' do
		email, password = params[:email], params[:password]
		user = User.authenticate(email, password)
		if user 
			session[:user_id] = user.id
			redirect to('/')
		else
			flash[:errors] = ["The email or password is incorrect."]
			erb :"sessions/new"
		end
	end

	delete '/sessions' do 
		flash[:notice] = "Good bye!"
		session[:user_id] = nil
		redirect to('/')
	end

	get '/users/reset_password' do 
		erb :"password/reset"
	end

	post '/users/reset_password' do 
		@email = params[:email]
		user = User.first(:email => @email)
		if user
			user.password_token = (1..64).map{("A".."Z").to_a.sample}.join
			user.password_token_timestamp = Time.now
			user.save
			erb :"password/reset"
		else
			redirect to('http://wompwompwomp.com/'), 301, 'No such user, mate.'
		end
	end

	get '/users/new_password' do
		@token = params[:token]
		@user = User.first(:password_token => @token)
		erb :"password/new"
	end


