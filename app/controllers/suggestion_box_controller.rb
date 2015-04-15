class SuggestionBoxController < ApplicationController
  include SlackHelper
  before_action :authenticate_user!
  before_action :update_current_user
  before_action :create_channel
  before_filter :get_history
  layout 'dashboard'

  def show
  end
end
