#!/usr/bin/ruby

#ENV[ 'RAILS_ENV' ] = ''
require File.dirname(__FILE__) + '/../config/environment.rb'

Person.all.each do |p|
  if p.id == 700
    p.delete
    next
  end

  groups =  p.groups.find_all { |g| g.group_type == 'Position Status' }
  p groups

  if groups.length == 0
    p.position_status = ''
  elsif groups.length == 1
    p.position_status = groups.first.name
  elsif groups.length > 1 then
    if groups.find { |x| x.name == 'Postdoc' }
      p.position_status = 'Postdoc'
    else
      p.position_status = groups.first.name
    end
      
  end
  p.save

  puts p.id.to_s + ' ' + p.last_name
  puts p.position_status
  puts

end

