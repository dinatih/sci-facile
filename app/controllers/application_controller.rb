class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    # This action can be used to render a default view or redirect to another action.
    render plain: "Welcome to the Application!"
  end
end
