#!/usr/bin/ruby

#ENV[ 'RAILS_ENV' ] = 'production'
require File.dirname(__FILE__) + '/../../config/environment.rb'

units = [
"Animal Biology",
"Biology",
"Crop Sciences",
"Entomology",
"INHS",
"Master's in Biology",
"Molecular and Cellular Biology",
"NRES",
"PEEC",
"Physiological & Molecular Plant Biology",
"Plant Biology",
"Professional Science Master's"
]

units.each do |u|
  x = Unit.new
  x.name = u
  x.save
end

p Unit.all
