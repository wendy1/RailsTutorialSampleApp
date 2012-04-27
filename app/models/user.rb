# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
class User < ActiveRecord::Base
  attr_accessible :name, :email
  validates :name, :presence => { :message => "cannot be blank.  User was not saved"},
    :length => { :maximum => 50 }
    
  email_regex = /\A[\w+\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => { :message => "cannot be blank.  User was not saved" },
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
end

