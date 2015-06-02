#!/usr/local/bin/ruby20

ENV['RAILS_ENV'] = 'production'
#DIR = File.dirname(__FILE__)
#require DIR + '/../config/environment.rb'
require '/rails/sib/config/environment.rb'
#require File.dirname(__FILE__) + '/../config/environment.rb'

netids = Hash.new
Person.all.each do |p|
  unless netids.has_key?( p.netid )
    netids[ p.netid ] = []
  end

  netids[ p.netid ] << p.id
end 

netids.each do |k,v|
  if v.length > 1
    puts "#{ k }: #{ v.join( ' ' ) }"
  end
end
