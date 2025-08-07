module ApplicationHelper
  def navbar_profile_link
    if logged_in?
      render partial: "layouts/profile_dropdown"
    else
      link_to "LOGIN", login_path, class: "nav-link"
    end
  end

  def admin_products_link
    if current_user&.admin?
      link_to "ADMIN PRODUCTS", admin_products_path, class: "nav-link"
    end
  end

  def cart_link
    if logged_in?
      link_to "CART", carts_path, class: "nav-link"
    end
  end
end
