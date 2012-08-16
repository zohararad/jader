require 'spec_helper'

describe Jade::Renderer do

  it 'render users index page' do
    get '/users'
    response.should render_template(:index)
  end

  it 'renders the template HTML' do
    get '/users'
    response.body.should include '<h1>Hello All Users</h1>'
  end

  it 'renders instance variables' do
    @user = stub_model(User, :name => 'Sam', :email => 'sam@gmail.com')
    User.should_receive(:find).and_return(@user)
    get user_path(@user)
    response.body.should include 'My name is %s' % @user.name
  end

end