class DashboardController < ApplicationController
  before_action :authenticate_user!
  include SlackHelper
  before_action :update_current_user
  layout 'dashboard'

  def show

  end
end
