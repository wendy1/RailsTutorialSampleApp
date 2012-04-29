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