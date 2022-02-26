class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in_as_admin?

  def wine_list
    @wine_list || Vinochipper.wine_list(3005)
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in_as_admin?
    logged_in_as?(User::ROLES[:admin])
  end

  def logged_in_as_customer?
    logged_in_as?(User::ROLES[:customer])
  end

  def logged_in_as?(role)
    return true unless current_user.nil? || current_user.role != role
    path = login_path
    path = "/#{current_user.role.downcase}" unless current_user.nil?

    flash[:notice]             = 'You must log in to see this page.'
    session[:orig_destination] = request.path
    redirect_to path
  end

  # TODO: Send an email or something!
  def log_error(message)
    Rails.logger.error(message)
  end

  def sync_to_xero(syncable, xero_class)
    xero_id = xero_class.create(current_user, syncable).id
    syncable.update(xero_id: xero_id) if syncable.xero_id.nil?
  rescue Xero::NotConnectedError => e
    log_error("#{current_user.name} #{e.message}")
  end
end
