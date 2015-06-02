class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?
  helper_method :admin?

  def logged_in?
  # returns true if session is 'logged in'
    session[ :logged_in ] ||
      ( Person.authorize?( session[ :netid ] ) && 
        Person.authenticate?( session[ :netid ], session[ :password ] ) )
  end

  def admin?
    logged_in?
  end

  # before_filter - used in controllers
  def admin
    unless session[ :admin ] || session[ :netid ] == Person.find_by_id( params[ :id ] ).netid
      flash[ :error ] = 'No access to ' + params[ :id ]
	  if request.env["PATH_INFO"]
      	redirect_to '/login?previous_page=' + request.env["PATH_INFO"] + '?' + request.env[ 'QUERY_STRING' ].gsub(/\&/,'%26')
	  else
	  	redirect_to '/login'
	  end
      false
    end
  end

end
