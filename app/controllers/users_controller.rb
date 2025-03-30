class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:become_host, :become_guest]

  def become_host
    @user.become_host!
    redirect_to root_path, notice: "You are now a host!"
  end

  def become_guest
    @user.become_guest!
    redirect_to root_path, notice: "You are now a guest!"
  end

  private

  def set_user
    @user = current_user
  end
end 