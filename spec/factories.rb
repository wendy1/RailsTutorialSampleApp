# by using the symbol ':user', we get Factory Girl to simulate the User model
# this defines the ability to write things like
#   @user = Factory(:user)
# in tests.  We can create this in the before(:each) block (or elsewhere)
Factory.define :user do |user|
  user.name "Michael Hartl"
  user.email  "example@railstutorial.org"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

# adding the associateion allows us to create posts bypassing mass assign restrictions 
# and lets us set create_at, which ActiveRecord doesn't allow.  
# Ex:
#  @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago
#  @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago
Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end