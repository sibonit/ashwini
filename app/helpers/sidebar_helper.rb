module SidebarHelper
  ### output HTML for sidebar or sitemap
  # generate_sidebar( current_path )
  # generate_sitemap()

  def generate_sidebar( current_path='' )
    sidebar_definition_filename = choose_sidebar_file

    menu, current_context = parse_and_create_menu_data_structure( current_path, sidebar_definition_filename )
logger.debug "Context: #{ current_context }"
logger.debug "Request path: #{ request.original_fullpath }"
logger.debug "Request url: #{ request.original_url }"
logger.debug "Current path: #{ current_path }"
    return sidebar_output( menu, current_context ).html_safe
  end


  
  def generate_dept_sidebar( dept, current_path='' )
    sidebar_definition_filename = choose_sidebar_file

    # take the complete menu
    menu, current_context = parse_and_create_menu_data_structure( current_path, sidebar_definition_filename )

    # select the appropriate MenuItem
    # Ugh, hard wired
    case dept
      when :biochemistry
        dept_menu = menu[ 3 ].submenu[ 0 ]
        door_jam = '/departments/biochemistry/graduate.html'
        home_menu_text = "Biochemistry"
        #door_jam = current_context
      when :cdb
        dept_menu = menu[ 3 ].submenu[ 1 ]
        door_jam = '/departments/cdb/graduate.html'
        home_menu_text = "Cell &amp; Developmental Biology"
      when :microbiology
        dept_menu = menu[ 3 ].submenu[ 2 ]
        door_jam = '/departments/microbiology/graduate.html'
        home_menu_text = "Microbiology"
      when :mip
        dept_menu = menu[ 3 ].submenu[ 3 ]
        door_jam = '/departments/mip/graduate.html'
        home_menu_text = "Molecular &amp; Integrative Physiology"
      else
    end

    # reset the levels down the tree
    dept_menu = adjust_level( dept_menu, dept_menu.level  )
    dept_menu.submenu.each do |s|
      s.level = 0
    end

    # set top menu to "Home"
    dept_menu.text = home_menu_text

    # sidebar_output expect to receive the menu wrapped in an array
    dept_menu_submenu = dept_menu.submenu
    dept_menu.submenu = []
    dept_menu = [ dept_menu, dept_menu_submenu ].flatten

    # create the sidebar
    #return sidebar_output( dept_menu, current_context )
    # Ugh, hard wiring context to force menu to always display fully
    return sidebar_output( dept_menu, door_jam ).html_safe
  end



  # def generate_2nd_sidebar
  #   # additional sidebar below CDB's revamped site
  # 
  #   out = '<ul class="navigation"
  #     <li><a href="/" title="School of MCB" >School of MCB</a></li>
  #   </ul>'
  # 
  #   return out.html_safe
  # end



  def generate_sitemap
    menu, current_context = parse_and_create_menu_data_structure
    return '<ul class="site_map">' + sitemap_output( menu ) + '</ul>'.html_safe
  end



  def choose_sidebar_file
    # find menu defintion in same directory as this file (app/helpers)
    sidebar_filename = case
      #when /\/departments\/cdb\//.match( request.url )
      #when true
      #  'sidebar_cdb.txt'
      when controller.controller_name == 'static'
        'sidebar_static.txt'
      when controller.controller_name == 'private'
        'sidebar_private.txt'
      else
        'sidebar_static.txt'
    end

    # return full path to file
    return File.dirname(__FILE__) + '/' + sidebar_filename
  end



  def parse_and_create_menu_data_structure( current_path='', sidebar_definition_filename='' )
debug_text = '' 
    # DEBUG: an example path to a document
    #current_path = '/about/visitorsguide.html'
    #current_path = '/about/'
    #current_path = '/undergrad/advising/'
  
    # a "register" for menus at each level
    # menus[ 0 ] will hold all the top-level MenuItems
    # menus[ 1..n] will hold submenus as they are being developed
    # when the submenu is finished, it is assigned to MenuItem#submenu
    # and then menus[ n ] is assigned nil to be ready to build the next submenu
    menus = []
    # a stack of MenuItem#path entries that describe the nesting to reach this MenuItem
    menu_item_context = []
    # the MenuItem#context that matches the currently requested document path
    current_context = nil
    # a stack of MenuItems that have submenus which are currently being built
    menu_items_with_unfinished_submenu = []
  
    previous_level = 0
    previous_menu_item = nil
  
    ### parse sidebar definition file
    file = File.open( sidebar_definition_filename )
    file.each_line do |line|
      # skip comment lines (starts with #)
      next if /^\s*#/.match( line )
      # skip blank lines
      next if /^\s*$/.match( line )
      # remove newline at end of line
      line.chomp!
  
      ### determine submenu level
      level, line = determine_submenu_level( line )
     
      ### parse link text & path
      # text begins the line, path follows after (spaces)(double equals sign)(spaces)
      text, path, auth = line.split( /\s*==\s*/ )

      ### check for MenuItem that requires authentication to be shown
      item_requires_auth = ( not auth.blank? )
      if item_requires_auth
        # lookup auth for current session
        # let 'admin' see everything
        next unless auth_includes?( auth ) or auth_includes?( :admin )
      end
  
      ### ignore_context - if path is preceeded by an asterix
      # i.e.: ==* /people, or == */people
      ignore_context = false
      ignore_context = true if path.sub!( /^\s*\*\s*/, '' )

      ### shrink and grow menu_item_context array
      menu_item_context = adjust_context_array( menu_item_context, level, path )

      ### assign data to MenuItem object
#logger.debug "path=" + path + ";context="+menu_item_context.inspect # if ignore_context
      m = MenuItem.new( text, path, level, menu_item_context, ignore_context )

      ### set current_context if the path to the request page matches the path for this MenuItem
      # use Regexp#match so that regular expressions can be used to create wildcards
      # in the menu definition file
      # only set current_context if it hasn't already been set
      if (not ignore_context) and ( not current_context ) and /^#{ m.path }\/?$/.match( current_path )
        current_context = m.context
logger.debug "m=" + m.path + 'current=' + current_path
      end
  
      ### process special context lines (where text starts with *)
      # submenu level notation already stripped off
      # simply skip adding this MenuItem to to menus
      # the main issue is to set current_context based on the *-line, which is done above
      context_only_item = line.sub!( /^\s*\*\s*/, '' )
      next if context_only_item

      # if we're starting a new level
      if level > previous_level
        # keep a reference to previous MenuItem, so we can assign submenu to it
        # once the submenu is complete
        menu_items_with_unfinished_submenu.push( previous_menu_item )
      end

      # if we're finishing off a level 
      # move submenu array(s) to next higher array in submenus
      # because we are about to record a new MenuItem at a higher level
      if level < previous_level
        ( previous_level ).downto( level + 1 ) do |i|
          menu_item_with_submenu = menu_items_with_unfinished_submenu.pop
#if menu_item_with_submenu.nil?
#debug_text = menu_items_with_unfinished_submenu.inspect
#end
          menu_item_with_submenu.submenu = menus[ i ] #unless menu_item_with_submenu.nil?
          menus[ i ] = nil
        end
      end
  
      ### route MenuItem into appropriate menu by level
      menus[ level ] = Array.new if menus[ level ].nil?
      menus[ level ] << m
  
      # hold on to previous_level and previous_menu_item for next iteration
      previous_level = level
      previous_menu_item = m
    end
  
    # set default current_context if one hasn't been set yet
    current_context = 'default' if current_context.nil?

    return menus[ 0 ], current_context
  end



  private


  def sitemap_output( menu_items, level=0 )
    indent = 0
    output = "\n" 

    menu_items.each do |m|
      level = m.level
      indent = level * 2
  
      # show all level 0 items and any items where the penultimate context
      # is included in the current context;
      # skip other entries
      #next if m.level > 0 and not current_context.include?( m.context[ -2 ] )
  
      indent_sp = ' ' * indent
  
      target = ''
      target = 'target="_blank"' if /^http/.match( m.path )
      target = '' if /life\.illinois\.edu/.match( m.path )

      dept_level_1 = ( ( m.level == 1 ) and ( m.context[ 0 ] == '/departments/' ) )

      output += indent_sp + '<li>'
      output += '<strong>' if level == 0 or dept_level_1
      output += '<a ' +  'href="' + m.path + '" title="' + m.text + '" ' + target + '>' + m.text + '</a>'
      output += '</strong>' if level == 0 or dept_level_1
  
      unless m.submenu.nil?
        output += "\n<ul>"
        output += sitemap_output( m.submenu, level )
        output += "\n</ul>"
      end

      output += '</li>'
      output += "\n"
    end
  
    return output
  end

  def sitemap_opening_tags( level )
    ul_tag = case
      when level == 0
      else
#        '<ul><li>'
        ''
    end
    indent = level * 2
    ' ' * indent + ul_tag
  end



  def sitemap_closing_tags( level )
    indent = level * 2
    out = ''
    out = ' ' * indent + '</ul>' if level == 0
    #out += '</li>' if level > 0
    return out
  end
  
  

  def determine_submenu_level( line )
    ### determine submenu level
    # match lines that begin with (spaces)(dashes)(spaces)
    level_re = /^\s*\-*\s*/
    # Regexp#match will return a MatchData object
    # MatchData[ 0 ] will be the matched string
    md = level_re.match( line )
    # level = number of dashes
    level = md[ 0 ].count( '-' )
    # then strip submenu marking from line
    line.sub!( level_re, '' )
    return level, line
  end
  
  
  
  def adjust_context_array( context, level, path )
    context = context.slice( 0, level )
    context.push( path )
    return context
  end
  
  
  
  def sidebar_opening_tags( level )
    if level == 0
      "<ul class='nav-level-#{level} unstyled'>"
    else
      "<li><ul class='nav-level-#{level}'>"
    end
  end
  
  
  
  def sidebar_closing_tags( level )
    indent = level * 2
    out = ''
    out = ' ' * indent + '</ul>'
    out += '</li>' if level > 0
    return out
  end
  
  
  
  def sidebar_output( menu_items, current_context, level=0 )
    indent = 0
    output = ''

    menu_items.each do |m|
      level = m.level
      indent = level * 2
 
      # skip items marked as 'ignore context' ( with ==* )
      #   as long as they're not top-level items
      #   or part of the current submenu
      next if m.ignore_context and m.level > 0 and (not current_context.include?( m.context[ -2 ] ) )

      # show all level 0 items and any items where the penultimate context
      # is included in the current context;
      # skip other entries
      next if m.level > 0 and not current_context.include?( m.context[ -2 ] )
  
      indent_sp = ' ' * indent
  
      item_selected = (current_context[ level ] == m.path)
      target = ''
      target = 'target="_blank"' if /^http/.match( m.path )
      target = '' if /life\.illinois\.edu/.match( m.path )
  
      output += indent_sp + '<li>'
      # output += '<a href="' + m.path + '" title="' + m.text + '" ' + target + '>' + m.text + '</a>'
      output += link_to m.text.html_safe, m.path, title: m.text, target: target, class: ("selected" if item_selected)
      output += '</li>'
      output += "\n"
  
      output += sidebar_output( m.submenu, current_context, level ) unless m.submenu.nil?
    end
  
    unless output == ''
      ### determine UL & other tags
      opening_tags = sidebar_opening_tags( level )
      closing_tags = sidebar_closing_tags( level )
  
      output =  opening_tags + "\n" + output
      output += closing_tags + "\n"
    end
  
    return output
  end


  #
  def adjust_level( menu_item, offset )
    return if menu_item.nil?

    menu_item.level -= offset

    return menu_item if menu_item.submenu.nil?
    menu_item.submenu.each do |mi|
      adjust_level( mi, offset )
    end

    return menu_item
  end
  
  
  
  class MenuItem
    attr_accessor :text, :path, :context, :level, :submenu, :ignore_context
    def initialize( text, path, level, context, ignore_context )
      # URL text
      @text = CGI::escapeHTML( text )
      # URL path
      @path = path
      # the level of submenu nesting at which this appears
      @level = level
      # array of URL paths to reach this item
      @context = context
      # array of MenuItems for nested submenu
      @submenu = nil
      # boolean
      @ignore_context = ignore_context
    end
  end
  
end
