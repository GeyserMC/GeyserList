module AuthHelper
  def service_sign_in_button(name, slug = name.downcase)
    button_text = "<i class=\"fab fa-#{slug}\"></i> Sign in with #{name}".html_safe
    button = button_tag(button_text, class: "mb-3 btn btn-lg btn-block btn-dark btn-#{slug}")

    link_to(button, "/login/#{slug}", class: 'text-decoration-none').html_safe
  end
end
