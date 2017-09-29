require 'rack-flash'
# TODO:

# 1. Move your routes to their own controller - UsersController - WishesController 
# 2. Lock down data to only be seen, editable or deletable from the owner of that data
# 3. Remove use of @user = current_user || @user = User.find_by(id: session[:user_id]) -> Just use current_user in the view
# 4. Clean up HTML 

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

end









