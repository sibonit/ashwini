class User < ActiveRecord::Base

  set_table_name "people"
  require 'net/ldap'

  ### autnetication & authorization methods

  def self.authorize?( netid )
    # check to see that netid is in people table
    person = Person.find_by_netid( netid )
    if person.nil?
      return false
    else
      true
    end
  end



  def self.exists?( username )
    # check to see that username is in Users table
    user = User.find_by_netid( username )
    if user.nil?
      return false
    else
      true
    end
  end



  def self.auth_to_session( username )
    # store Person.auth string in session[ :auth ]
    user = User.find_by_netid( username )
    return '' if user.auth.nil?
    user.auth
  end



  def self.initialize_ldap( netid, password )
    ldap = Net::LDAP.new
    ldap.host = 'ad.uiuc.edu'
    ldap.port = 636
    ldap.encryption( :simple_tls )
    ldap.auth( netid, password )
  
    ldap
  end
  


  def self.authenticate?( netid, password )
    return false if netid.nil? || password.nil?
    return false if netid.empty? || password.empty?
  
    treebase = 'OU=Campus Accounts,DC=ad,DC=uiuc,DC=edu'

    # bind with the server's credentials
    server_dn = "cn=app_rails,ou=life,dc=ad,dc=uiuc,dc=edu"
    server_password = 'zTayExT5'
    ldap = initialize_ldap( server_dn, server_password )
  
    # bind_as searches for account and re-binds
    result = ldap.bind_as(
      :base => treebase,
      :filter => "(cn=#{ netid })",
      :password => password
    )
  
    # bind_as will return false if re-binding failed
    # check that we only matched one record
    if result and result.length == 1
      #puts "Authenticated #{ result.first.dn }"
      return true
    else
      #puts "Authentication FAILED."
      return false
    end
  
  end
	
end
