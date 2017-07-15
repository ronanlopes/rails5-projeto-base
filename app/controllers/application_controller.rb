class ApplicationController < ActionController::Base

	before_action :authenticate_user!
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }


  #rescue_from CanCan::AccessDenied do |exception|
  #  render "pages/403", :layout => !request.xhr?
  #  Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}" if Rails.env.development?
  #end

  def after_sign_in_path_for(user)
    ((current_user.sign_in_count == 1) ? edit_user_registration_path : root_url)
  end


  def index
  end

end
