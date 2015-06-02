#!/usr/bin/ruby

require 'rubygems'
require 'net/ldap'

$service_dn = "cn=life-app-rails,ou=useraccounts,ou=life,ou=las,ou=urbana,dc=ad,dc=uillinois,dc=edu"
$service_password = 'zTayExT5'

def main

  print "Username: "
  username = gets.chomp

  # primitive method to hide password
  `stty -echo`
  print "Password: "
  password = gets.chomp
  `stty echo`

  puts

  result = authenticate?( username, password )
  puts result

end

def initialize_ldap( username, password )
  ldap = Net::LDAP.new
  ldap.host = 'ad.uillinois.edu'
  ldap.port = 389
  ldap.encryption( :start_tls )
  ldap.auth( username, password )

  return ldap
end

def authenticate?( username, password )
  return false if username.nil? || password.nil?
  return false if username.empty? || password.empty?
 
  treebase = 'DC=ad,DC=uillinois,DC=edu'

  # bind with the service's credentials
  ldap = initialize_ldap( $service_dn, $service_password )

  # bind_as searches for account and re-binds
  result = ldap.bind_as(
    :base => treebase,
    :filter => "(cn=#{ username })",
    :password => password
  )

  # bind_as will return false if re-binding failed
  # check that we only matched one record
  if result and result.length == 1
    puts "Authenticated #{ result.first.dn }"
    return true
  else
    puts "Authentication FAILED."
    return false
  end

end

main()
