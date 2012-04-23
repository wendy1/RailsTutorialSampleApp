require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'app/controllers/pages_controller.rb'" do
    it "should be successful" do
      get 'app/controllers/pages_controller.rb'
      response.should be_success
    end
  end

  describe "GET 'route'" do
    it "should be successful" do
      get 'route'
      response.should be_success
    end
  end

  describe "GET 'get'" do
    it "should be successful" do
      get 'get'
      response.should be_success
    end
  end

  describe "GET 'pages/contact'" do
    it "should be successful" do
      get 'pages/contact'
      response.should be_success
    end
  end

  describe "GET 'route'" do
    it "should be successful" do
      get 'route'
      response.should be_success
    end
  end

  describe "GET 'get'" do
    it "should be successful" do
      get 'get'
      response.should be_success
    end
  end

  describe "GET 'pages/home'" do
    it "should be successful" do
      get 'pages/home'
      response.should be_success
    end
  end

end
