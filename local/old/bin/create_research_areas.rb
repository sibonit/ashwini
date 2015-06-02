#!/usr/bin/ruby

#ENV[ 'RAILS_ENV' ] = 'production'
require File.dirname(__FILE__) + '/../../config/environment.rb'

research_areas = [
"Behavior",
"Ecology",
"Evolution & Systematics",
"Genetics & Biochemistry",
"Physiology & Development"
]

research_areas.each do |u|
  x = ResearchArea.new
  x.name = u
  x.save
end

p ResearchArea.all
