class ApplicationController < ActionController::Base
  helper_method :current_user, :must_be_admin

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

  def must_be_admin
    must_be(User::ROLES[:admin])
  end

  def must_be_customer
    must_be(User::ROLES[:customer])
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

  private

  def must_be(role)
    return if logged_in_as?(role)

    flash[:notice]             = 'You must log in to see this page.'
    session[:orig_destination] = request.path
    redirect_to redirect_path
  end

  def logged_in_as?(role)
    !current_user.nil? && current_user.role == role
  end

  def redirect_path
    return "/#{current_user.role.downcase}" unless current_user.nil?

    login_path
  end
end
