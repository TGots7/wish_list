class ApplicationController < Sinatra::Base

	configure do
		set :public_folder, 'public'
		set :views, "app/views"
		enable :sessions
		set :session_secret, "secret"
	end

	helpers do
	    def logged_in?
	      !!session[:user_id]

	    end
	    def current_user
	      User.find(session[:user_id])
	    end
	 end

	get '/' do
		erb :index
	end

	get '/sign_up' do
		erb :'/users/sign_up'
	end

	post '/sign_up' do 
		if params[:name].empty? || params[:email].empty? || params[:password].empty?
			redirect '/sign_up'
		else
			@user = User.new(:name => params[:name])
			@user.email = params[:email]
			@user.password = params[:password]
			@user.save
			session[:user_id] = @user.id 

			redirect '/users/home'
		end
	end

	get '/log_in' do 
		if logged_in?
			redirect '/users/home'
		else
			erb :'/users/log_in'
		end
	end

	post '/log_in' do 
		if params[:name].empty? || params[:email].empty? || params[:password].empty?
			redirect '/log_in'
		else
			@user = User.find_by(email: params[:email])
			if @user && @user.authenticate(params[:password])
				session[:user_id] = @user.id
				redirect '/users/home'
			else
				redirect '/log_in'
			end
		end
	end

	get '/users/home' do 
		if logged_in?	
			@user = User.find(session[:user_id])
			erb :'/users/home'
		else
			redirect '/'
		end
	end

	get '/wishes/add_wish' do
		erb :'/wishes/add_wish'
	end

	post '/new_wish' do
		if logged_in?
			@user = User.find(session[:user_id])
			@new_wish = Wish.new(:content => params[:wish])
			@new_wish.user_id = @user.id #which ever user is logged in
			@new_wish.save
			
			erb :'/wishes/new_wish'
		else
			redirect '/'
		end
	end

	get '/all_wishes' do
		if logged_in?
			@user = current_user
			erb :'/wishes/all_wishes'
		else
			redirect '/'
		end
	end

	get '/wishes/:id/edit' do
		@wish = Wish.find_by_id(params[:id])
		erb :'/wishes/edit_wish'
	end

	patch '/wishes/:id' do
		if logged_in?
			@wish = Wish.find_by_id(params[:id])
			@wish.content = params[:content]
			@wish.save

			redirect '/users/home'
		else
			redirect '/'
		end
	end

	# get '/wishes/<%= wish.id %>/delete' do
	#  	@wish = Wish.find_by_id(params[:id])
	# 	erb :'/wishes/edit_wish'
	# end

	delete '/wishes/:id/delete' do
		if logged_in?
			@wish = Wish.find_by_id(params[:id])
			@wish.delete

			redirect '/users/home'
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









