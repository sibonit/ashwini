#!/usr/bin/ruby

#ENV[ 'RAILS_ENV' ] = ''
require File.dirname(__FILE__) + '/../../config/environment.rb'

units = Unit.all

Person.all.each do |p|

  groups =  p.groups.find_all { |g| g.group_type == 'Unit' }

  groups.each do |g|
    u = units.find { |x| x.name == g.name }
    p.units << u
  end

  puts p.id.to_s + ' ' + p.last_name
  p groups
  p p.units
  puts

end

