class UserPresenter < Draper::Decorator
  delegate_all
  
  def admin_navbar
    return '' unless admin?

    helpers.render 'shared/admin_navbar'
  end

  def user_navbar
    return '' unless user?

    helpers.render 'shared/user_navbar'
  end
end
