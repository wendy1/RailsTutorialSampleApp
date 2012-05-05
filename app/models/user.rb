# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
    :class_name => "Relationship",
    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  validates :name, :presence => { :message => "cannot be blank.  User was not saved"},
    :length => { :maximum => 50 }
    
  email_regex = /\A[\w+\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => { :message => "cannot be blank.  User was not saved" },
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
    
  # automatically create the virtual attribute 'password_confirmation
  validates :password, :presence => { :message => "cannot be blank" },
      :confirmation => true,
      :length => { :within => 6..40 }
      
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    # compare encrypted password with teh encrypted verison of the submitted password
    return false if new_record?
    encrypted_password = encrypt("#{salt}--#{submitted_password}")
    return encrypted_password == self.encrypted_password
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email) 
    return nil if user.nil?
    return user if user.has_password? (submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  def feed
    # preliminary definition - more in chapter 12
    Micropost.where("user_id = ?", id)
  end

  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt("#{salt}--#{password}")
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end

