class Route404Controller < ApplicationController

  def index
   render :file => "#{RAILS_ROOT}/public/404.html",  
     :status => 404 and return
  end

end
