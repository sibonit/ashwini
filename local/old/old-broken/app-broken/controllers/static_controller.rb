class StaticController < ApplicationController

  layout 'application'

# Notes:
# calling "render :file" will cause some sort of caching
# even in development mode
# use "File.open + render :inline" to avoid caching
# "render :text" doesn't interpret ERB statements

#  def index
#    render :layout => 'static/base'
#  end


#  def method_missing(method_name, *args)
  def method_missing
    path = request.path

    #if File.directory?( 'app/views/static' + path )
    if File.directory?( 'app/views' + path )
      # if the file path is a directory, but the URL doesn't end with a slash
      # (this helps with relative paths for URLs contained in the document)
      # Rails 3 suppresses trailing slashes in request.path
      # Use request.original_url, request.original_fullpath or request.env[ 'REQUEST_URI' ]
      if ! /\/$/.match( request.original_url )
        redirect_to( request.path + '/' )
        return
      end
      # Since the request is for a directory
      path = path + '/index'
    end

    # Try to render a view at the given path, if it doesn't exist show 404 error
    #render "static#{ path }" rescue render 'static/404.html'
    render path rescue render '404.html'
  end

end
