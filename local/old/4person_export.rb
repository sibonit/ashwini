#!/usr/bin/ruby
# get SIB phone data for UC
# direct output to a file

RAILS_ENV = 'production'
require File.dirname(__FILE__) + '/../config/environment.rb'

# list of field names we want
fields_to_export = %w[
last_name
first_name
email
office_phone
office_address
position_status
department
]

dept_hash = {
'None' => '18',
'Animal Biology' => '1',
'Animal Sciences' => '13',
'Biology Library' => '2',
'Cell and Developmental Biology' => '3',
'Entomology' => '4',
'Integrative Biology' => '5',
'Molecular and Cellular Biology' => '7',
'Plant Biology' => '6',
'INHS-CDB' => '8',
'INHS-CAE' => '10',
'INHS' => '11',
'MIP' => '12',
'Crop Science' => '14',
'Biophysics' => '16',
'NRES' => '9',
'IGB' => '17',
'Biochemistry' => '19',
'Microbiology' => '15'
}.invert

Person.all.each do |p|
  unless p.office_phone.empty?
    line=[]
    fields_to_export.each do |f|
      value = p.send(f)
      value = dept_hash[value] if f=="department"
      line << value
    end
    puts line.join("\t")
  end
end 
