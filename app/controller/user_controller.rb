class UserController < ApplicationController

	get '/sign_up' do
		
		if logged_in?
			redirect '/home'
		else
			erb :'/users/sign_up'
		end
	end

	post '/sign_up' do 
		if params[:username].empty? || params[:email].empty? || params[:password].empty?
			flash[:message] = "Please, properly fill out Sign Up form"
			redirect '/sign_up'
		else
			@user = User.new(:username => params[:username])
			@user.email = params[:email]
			@user.password = params[:password]
			@user.save
			session[:user_id] = @user.id 

			flash[:message] = "You signed up!"
			redirect '/home'
		end
	end

	get '/log_in' do 
		if logged_in?
			redirect '/home'
		else
			erb :'/users/log_in'
		end
	end

	post '/log_in' do 
		if params[:username].empty? || params[:password].empty?
			flash[:message] = "Please, properly fill out Log In form"
			redirect '/log_in'
		else
			@user = User.find_by(username: params[:username])
			if @user && @user.authenticate(params[:password])
				session[:user_id] = @user.id

				flash[:message] = "You logged in!"
				redirect '/home'
			else
				redirect '/log_in'
			end
		end
	end

	get '/home' do 
		
		if logged_in?	
			@events = Event.all
			erb :'/users/home'
		else
			redirect '/'
		end
	end

	get '/logout' do
		if logged_in?
			session.clear
			redirect '/'
		else
			redirect '/'
		end
	end

end