#!/usr/bin/ruby

require 'rubygems'
require 'net/ldap'

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
 
  dn = "CN=#{ username },OU=People,DC=ad,DC=uillinois,DC=edu"

  # bind with the server's credentials
  ldap = initialize_ldap( dn, password )

  if ldap.bind
    # authentication succeeded
    puts "Authenticated!"
    return true
  else
    # authentication failed
    puts "Authentication FAILED."
    return false
  end

end

main()
