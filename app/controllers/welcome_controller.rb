class WelcomeController < ApplicationController
 
#KA: USing for news on home page
 def index
	 @news = NewsItem.all
	 @events = CalendarEvent.all

 end


	#KA: By explicitly defining the fields in the form, we can control any malicious code from being entered in the form.
	# Also putting this into its own method will help us reuse it for multiple actions (create, update etc)
	private
  		def article_params
			params.require(:article).permit(:title, :text) 
	  		end
	end
