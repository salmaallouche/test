class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_language
  helper_method :current_company
  helper_method :current_product_types
  helper_method :allowed_segments
  helper_method :current_segment
  helper_method :current_cart

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  before_filter :is_asset_reviewer? 
  skip_before_filter :is_asset_reviewer?, if: :devise_controller?
  private
  # Set the current locale from params  
  # 
  def set_language

    if current_user.nil? || params[:controller] =~ /rails_admin/i
     I18n.locale = params[:language] || I18n.default_locale
    else
      I18n.locale = params[:language] || current_user.language.try(:iso_code) || I18n.default_locale
    end
  end

  # Overwriting the sign_in redirect path method
  #
  def after_sign_in_path_for(resource_or_scope)
    if params[:return_to].present?
      session[:return_to] = params[:return_to]
    elsif session[:return_to].present?
      session[:return_to]
    else
      root_url
    end
  end

  def is_graphic_artist?
    redirect_to '/media/my_production' if current_user && current_user.has_role?(:graphic_artist)
  end

  def is_asset_reviewer?
    redirect_to '/media/my_production' if current_user && current_user.has_role?(:asset_reviewer)
  end
