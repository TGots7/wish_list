class WishController < ApplicationController

	get '/wishes/new' do
		@events = Event.all
		erb :'/wishes/new'
	end

	post '/wishes' do
		@events = Event.all
		if params[:wish].empty? || params[:wish] == "Add a wish"
			flash[:message] = "Please properly fill out a wish"
			redirect '/wishes/new'
		else
			if logged_in?
				@new_wish = current_user.wishes.build(params[:wish])
				if params["event"].empty?
					@new_wish.save
				else
					@new_wish.events << Event.find_or_create_by(:event => params["event"])
					@new_wish.save
				end
				
				flash[:message] = "Here is your newly created wish!"
				erb :'/wishes/show'
			else
				redirect '/'
			end
		end
	end

	get '/wishes' do
		if logged_in?
			@wishes = Wish.all
			@events = Event.all
			erb :'/wishes/index'
		else
			redirect '/'
		end
	end
	#only be able to edit if the wish is the current_users
	get '/wishes/:id/edit' do
		if logged_in?
			if @wish = current_user.wishes.find_by_id(params[:id])
				@events = Event.all
				erb :'/wishes/edit'
			else
				redirect '/home'
			end
		else
			redirect '/'
		end
	end

	patch '/wishes/:id' do
		if params[:wish].empty?
			redirect '/home'
		elsif logged_in?
			if @wish = current_user.wishes.find_by_id(params[:id])
				@wish.content = params[:content]
				@wish.update(params[:wish])
				@wish.save

				flash[:message] = "Your wish was edited"
			else 
				flash[:message] = "Your unable to edit this wish"
			end
			redirect '/home'
		else
			redirect '/'
		end
	end

	delete '/wishes/:id/delete' do
		if logged_in? 
			if @wish = current_user.wishes.find_by_id(params[:id])
				@wish.delete
				flash[:message] = "Your wish was deleted"
				redirect '/home'
			else
				redirect '/home'
			end
		else
			redirect '/'
		end
	end
	
end