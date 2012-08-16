class UsersController < ApplicationController

  def index
    @users = User.where('name != "Jim"')
  end

  def show
    @user = User.find params[:id]
  end
end