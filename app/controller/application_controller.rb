class ApplicationController < Sinatra::Base

	configure do
		set :public_folder, 'public'
		set :views, "app/views"
		enable :sessions
		set :session_secret, "secret"
	end

	get '/' do
		erb :index
	end

	get '/sign_up' do
		erb :'/users/sign_up'
	end

	post '/sign_up' do 
		@user = User.new(:name => params[:name])
		@user.email = params[:email]
		@user.password = params[:password]
		@user.save

		redirect '/log_in'
	end

	get '/log_in' do 
		erb :'/users/log_in'
	end

	post '/log_in' do 
		@user = User.find_by(email: params[:email])

		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			redirect '/users/home'
		else
			redirect '/log_in'
		end
	end

	get '/users/home' do 
		@user = User.find(session[:user_id])
		

		erb :'/users/home'
	end

end