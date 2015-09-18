class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :set_locale

  # 全リンクにlocale情報をセットする
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
  
  # リンクの多言語化に対応する
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "please log in."
      redirect_to login_url
    end
  end
end
