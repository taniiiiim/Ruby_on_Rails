module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end
end

def log_in_as(user)
  session[:user_id] = user.id
end
