# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe UpdatesController do
  
  fixtures :users, :updates
  
  it 'should allow anyone to view the updates index' do
    get :index
    response.should be_success
  end
  
  it "should not allow a normal user to edit an update" do
    login users(:arthur)
    get :edit, :id => updates(:valid)
    response.should_not be_success
  end
  
  it 'should not let a guest edit an update' do
    get :edit, :id => updates(:valid)
    response.should_not be_success    
  end
  
  it 'should not let a guest update or destroy an update' do 
    put :update, :id => updates(:valid), :title => 'change me'
    response.should_not be_success
  end
  
  it "should allow an admin to edit a blog entry" do
    login users(:sudara)
    controller.should_receive(:logged_in?).and_return true
    get :edit, :id => updates(:valid).permalink
    controller.session["user_credentials"].should == users(:arthur).persistence_token 
    response.should be_success
  end
  
  it "should allow an admin to update a blog entry" do 
    login users(:sudara)
    put :update, :id => updates(:valid).permalink, :title => 'change me'
    response.should be_success
  end
  
  it "should not let a normal joe create a blog entry" do
    post :create, :title => 'new', :content => 'report'
    response.should_not be_success
  end


end
