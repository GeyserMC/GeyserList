module ModHelper
  # Adds a item to a sidebar dropdown
  # @param name [String] the name (shown on the dropdown)
  # @param href [String] where to actually link to
  # @param fa_icon [String] the icon to show before the text
  def dropdown_item(name: '', href: '#', fa_icon: nil, badge: nil)
    tag = '<li class="nav-item">'
    tag += "<a class='nav-link #{'active' if request.path == href}' href='#{href}'>"
    tag += "<i class=\"#{fa_icon} nav-icon\"></i> " if fa_icon
    tag += "<p>" + name
    tag += "<span class='right badge badge-danger'>#{badge}</span>" if badge
    tag += "</p>"
    tag += "</a>"
    tag += "</li>"
    tag.html_safe
  end
end
