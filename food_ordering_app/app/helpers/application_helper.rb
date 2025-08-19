module ApplicationHelper
  def navbar_profile_link
    if logged_in?
      link_to current_user.name, "#", class: "nav-link dropdown-toggle", id: "profileDropdown", role: "button", data: { bs_toggle: "dropdown" }, aria: { expanded: false }
    end
  end

  def admin_products_link
    if current_user&.admin?
      link_to "PRODUCTS", admin_products_path, class: "nav-link"
    end
  end

  def admin_users_link
    if current_user&.admin?
      link_to "USERS", admin_users_path, class: "nav-link"
    end
  end

  def admin_orders_link
    if current_user&.admin?
      link_to "ORDERS", admin_orders_path, class: "nav-link"
    end
  end

  def cart_link
    if logged_in? && !current_user.admin?
      link_to "CART", carts_path, class: "nav-link"
    end
  end

  def navbar_home_link
    unless controller.class.name.include?('Main')
      link_to "HOME", root_path, class: "nav-link"
    end
  end

  def navbar_about_link
    link_to "ABOUT", "#", class: "nav-link"
  end

  def navbar_contacts_link
    link_to "CONTACTS", "#", class: "nav-link"
  end

  def navbar_login_link
    unless logged_in?
      link_to "LOGIN", login_path, class: "nav-link"
    end
  end

  def navbar_register_link
    unless logged_in?
      link_to "REGISTER", register_path, class: "nav-link"
    end
  end
end
