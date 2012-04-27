require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)  # create! raises exception if it fails
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))  # merge replaces :name with "" value, creating an invalid user
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_name_user = User.new(@attr.merge(:email => ""))  # merge replaces :name with "" value, creating an invalid user
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51;
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com foo.org @foo.bar.org first.last@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    # put each user with a given email address into the database
    User.create(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
    
    # check case insensitivity too
    duplicate_user = User.new(@attr.merge(:email => @attr[:email].upcase))
    duplicate_user.should_not be_valid
  end
  
end
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

