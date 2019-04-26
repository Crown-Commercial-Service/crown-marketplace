class UserConstraint
  def matches?(request)
    return false unless request.session[:login]

    login = Login.from_session(request.session[:login])
    login.present?
  end
end
