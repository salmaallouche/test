class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_language
  helper_method :current_company
  helper_method :current_product_types
  helper_method :al