require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com", :password => "aaaaaa", :password_confirmation => "aaaaaa"}
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

describe "micropost assciations" do
  
  before(:each) do
    @user = User.create(@attr)
    @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
    @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
  end
  
  describe "status feed" do
    
    it "should have a feed" do
      @user.should respond_to(:feed)
    end
    
    it "should include the user's microposts" do
      @user.feed.include?(@mp1).should be_true
      @user.feed.include?(@mp2).should be_true
    end
    
    it "should not include a different user's microposts" do
      mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
      @user.feed.include?(mp3).should be false
    end
    
  end

end

describe "password validations" do
  
  it "should require a password" do
    User.new(@attr.merge(:password => "", :password_confirmation => ""))
      .should_not be_valid
  end
    
  it "should require a matching password confirmation" do
    User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
  end
  
  it "should reject short passwords" do
    short = "a" * 5
    hash = @attr.merge(:password => short, :password_confirmation => short)
    User.new(hash).should_not be_valid
  end
  
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  
  end

  describe "password encryption" do
  
    before(:each) do
      @user = User.create!(@attr)
    end
  
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "has_password? method" do
 
    before(:each) do
      @user = User.create!(@attr)
    end
  
    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end
    
    it "should be faluse if the passwords don't match" do
      @user.has_password?("invalid").should be_false;
    end
    
  end
  
  describe "authenticate method" do
    
    it "should return nil on pemail/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end
    
    it "should return nil for an email address with no user" do
      nonexistant_user = User.authenticate("bar@foo.com", @attr[:password])
      nonexistant_user.should be_nil
    end
    
    it "should return the user on email/password match" do
      good_user = User.authenticate(@attr[:email], @attr[:password])
      good_user.should == @user
    end
    
  end
  
  describe "admin attribute" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
    
  end

end

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

