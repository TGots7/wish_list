require 'rack-flash'

class ApplicationController < Sinatra::Base

	use Rack::Flash

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
		
		if logged_in?
			redirect '/home'
		else
			erb :'/users/sign_up'
		end
	end

	post '/sign_up' do 
		if params[:name].empty? || params[:email].empty? || params[:password].empty?
			flash[:message] = "Please, properly fill out Sign Up form"
			redirect '/sign_up'
		else
			@user = User.new(:name => params[:name])
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
		if params[:name].empty? || params[:email].empty? || params[:password].empty?
			flash[:message] = "Please, properly fill out Log In form"
			redirect '/log_in'
		else
			@user = User.find_by(email: params[:email])
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
			@user = User.find(session[:user_id])
			erb :'/users/home'
		else
			redirect '/'
		end
	end

	get '/add_wish' do
		
		erb :'/wishes/add_wish'
	end

	post '/new_wish' do
		if params[:wish].empty? || params[:wish] == "Add a wish"
			flash[:message] = "Please properly fill out a wish"
			redirect '/add_wish'
		else
			if logged_in?

				@user = User.find(session[:user_id])
				@new_wish = Wish.create(params[:wish])
				@new_wish.user_id = @user.id #which ever user is logged in
				if params["event"].empty?
					@new_wish.save
				else
					@new_wish.events << Event.find_or_create_by(:event => params["event"])
					@new_wish.save
				end
				
				flash[:message] = "Here is your newly created wish!"
				erb :'/wishes/new_wish'
			else
				redirect '/'
			end
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
		if params[:wish].empty?
			redirect '/home'
		else
			if logged_in?
				@wish = Wish.find_by_id(params[:id])
				@wish.content = params[:content]
				@wish.update(params[:wish])
				@wish.save

				flash[:message] = "Your wish was edited"
				redirect '/home'
			else
				redirect '/'
			end
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

			flash[:message] = "Your wish was deleted"
			redirect '/home'
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









