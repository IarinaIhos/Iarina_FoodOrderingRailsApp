module ApplicationHelper
  def navbar_profile_link
    if logged_in?
      render partial: "layouts/profile_dropdown"
    else
      link_to "Login", login_path, class: "nav-link"
    end
  end
end