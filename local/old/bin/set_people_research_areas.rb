#!/usr/bin/ruby

#ENV[ 'RAILS_ENV' ] = ''
require File.dirname(__FILE__) + '/../../config/environment.rb'

ras = ResearchArea.all

Person.all.each do |p|

  groups =  p.groups.find_all { |g| g.group_type == 'Research Area' }

  groups.each do |g|
    u = ras.find { |x| x.name == g.name }
    p.research_areas << u
  end

  puts p.id.to_s + ' ' + p.last_name
  p groups
  p p.research_areas
  puts

end

