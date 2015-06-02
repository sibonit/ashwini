# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def set_focus(id)
    #javascript_tag("$('#{id}').focus()")
    javascript_tag("document.getElementById('#{id}').focus()")
  end
  
#  def link_to_add_fields(name, f, association)
#    new_object = f.object.send(association).klass.new
#    id = new_object.object_id
#    fields = f.fields_for(association, new_object, child_index: id) do |builder|
#      render(association.to_s.singularize + "_fields", f: builder)
#    end
#    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
#  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  

  
	def get_tabs
		if @tab_html
			return @tab_html
		else
			return ""
		end
	end
	
	def get_categories
		if @category_html
			return @category_html
		else
			return ""
		end
	end
  
	def get_css
		if @group_css
			return @group_css
		else
			return ""
		end
	end
  
	def get_welcome
		if @welcome_html
			return @welcome_html
		else
			return ""
		end
	end

	def check_access?
		if session[ :admin ] || @access
			return true
		else
			return false
		end
	end
end
