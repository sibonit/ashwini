class StaticController < ApplicationController

  layout :choose_layout

# Notes:
# calling "render :file" will cause some sort of caching
# even in development mode
# use "File.open + render :inline" to avoid caching
# "render :text" doesn't interpret ERB statements

  def index
#DEBUG
#@submenu = :about
#@submenu = :departments
@submenu = :resources

    # 'static' documents are in app/views/static
    # path is relative from template home ( app/views )
    path = 'static' 

    # set path from params if available
    #path = 'static/' + params[:path].join('/') unless params[ :path ].nil?
    path = 'static/' + params[:path] unless params[ :path ].nil?
# DEBUG
#@path = path


    # file_path is relative from Rails home
    file_path = 'app/views/' + path
    full_path = Rails.root.to_s + '/app/views/' + path

    
#logger.debug " value = " + request.url
    # if the file_path is a directory, but the URL doesn't end with a slash
    # (this helps with relative paths for URLs contained in the document)
#    if File.directory?( file_path )# && ! /\/$/.match( request.path )
    # Rails 3 suppresses trailing slashes in request.path
    # Use request.original_url, request.original_fullpath or request.env[ 'REQUEST_URI' ]
    if File.directory?( file_path ) && ! /\/$/.match( request.original_url )
      redirect_to( request.path + '/' )
      return
    end

    file_to_render = nil
    case
    # if the file_path is a directory
    when File.directory?( file_path )
      file_to_render = full_path + '/index.html.erb'
      # use .html if .html.erb doesn't exist
#      file_to_render = full_path + '/index.html' unless File.exists?( file_to_render )
    # if the file_path is a plain file and ends with .html
#    when File.file?( file_path ) && /\.html$/.match( file_path )
#      file_to_render = full_path
    # if the file_path with .html appended is a plain file
#    when File.file?( file_path + '.html' )
#      file_to_render = full_path + '.html'
    # if the file_path with .html.erb appended is a plain file
    when File.file?( file_path + '.html.erb' )
      file_to_render = full_path + '.html.erb'
    end

    unless file_to_render.nil?
      file = File.open( file_to_render )
      file_contents = file.read
      file.close
      render :inline => file_contents, :layout => true #, :formats => [ :html ]
    else
      #render :file => Rails.root.to_s + '/app/views/static/404.html', :layout => true, :status => 404, :formats => [ :html ]
      render :file => Rails.root.to_s + '/public/404.html', :layout => true, :status => 404, :formats => [ :html ]
# DEBUG
#      raise ::ActionController::RoutingError,
#            "Recognition failed for #{request.path.inspect} #{ path }"
    end

  end


  private

  def choose_layout
    'two_column'
  end


end
