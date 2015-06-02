class Course < ActiveRecord::Base

  def area_and_additional
    shown = ""
	if advanced_comp
		shown = "Meets Advanced Composition Requirement"
	end
	if area1_course
		if shown == ""
			shown = "A1"
		else
			shown = shown + ", A1"
		end
	end
	if area2_course
		if shown == ""
			shown = "A2"
		else
			shown = shown + ", A2"
		end
	end
	if area3_course
		if shown == ""
			shown = "A3"
		else
			shown = shown + ", A3"
		end
	end
	if additional_approved_course
		if shown == ""
			shown = "AA"
		else
			shown = shown + ", AA"
		end
	end
	if lab_section != "None"
		shown = shown + "*"
	end
	
	return shown
		
	
  end


end

