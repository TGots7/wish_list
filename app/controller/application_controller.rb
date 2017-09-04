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

	get '/log_in' do 
		erb :'/users/log_in'
	end

end