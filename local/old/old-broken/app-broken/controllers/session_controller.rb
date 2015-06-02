class SessionController < ApplicationController
#  skip_before_filter :authorize, :except => :destroy

  def index
    # 'reset_session' will clear flash messages!
    # reset_session
	
    session[ :password ] = nil
    session[ :logged_in ] = false
    session[ :admin ] = false
	session[ :MSTOnline ] = false
    @Person = Person.new
  end


  def create
    netid = session[ :netid ] = params[ :netid ].downcase
    session[ :password ] = params[ :password ]
    session[ :logged_in ] = false
    session[ :admin ]     = false
	session[ :MSTOnline ] = false

    if logged_in?
      # use this token to prove that we're logged in
      session[ :logged_in ] = true
      # clear password so we don't have it stored in the session any longer than necessary
      session[ :password ] = nil
      # allow admin access if Person is designated as admin
      session[ :admin ] = true if Person.admin?( netid )
      # allow admin access if Person is designated as admin
      session[ :MSTOnline ] = true if Person.MSTOnline?( netid )
	  

      if params[ :previous_page ]
      	redirect_to params[ :previous_page ]
	  else
	    redirect_to '/'
	  end
    else # not logged in
      unless Person.authorize?( netid )
        flash[ :error ] = 'Authorization failed'
      else
        flash[ :error ] = 'Authentication failed'
      end

      if params[ :previous_page ]
      	redirect_to '/login?previous_page=' + params[ :previous_page ]
      else
        redirect_to '/login'
      end
    end

  end


  def destroy
    reset_session
	
    flash[ :notice ] = 'Successfully logged out' + params[ :previous_page ]
    redirect_to params[ :previous_page ]
  end
  
  
  protected

  # used by SslRequirement plugin
  def ssl_required?
    true
  end

end
