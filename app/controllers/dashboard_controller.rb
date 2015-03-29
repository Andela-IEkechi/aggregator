class DashboardController < ApplicationController
  include SlackHelper
  before_action :authenticate_user!
  before_action :update_current_user
  layout 'dashboard'

  def show
  end
end
