class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.includes(:profile)
  end
  # GET to /users/:id
  def show
    @user = User.find(current_user.id)
  end
end