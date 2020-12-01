module ApplicationHelper
  # Adds necessary tags for meta where needed
  # @param title [String] The title of the page. Appears in navbar and embed titles. Do not include "- GeyserList"
  # @param description [String] Embed description
  # @param color [String] Embed color
  def meta_tags(title: 'GeyserList', description: 'GeyserList', color: '#2b5797')
    [
      tag.title("#{title} - GeyserList"),
      tag('meta', property: 'og:title', content: "#{title} - GeyserList"),
      tag('meta', property: 'twitter:title', content: "#{title} - GeyserList"),
      tag('meta', property: 'description', content: description.to_s),
      tag('meta', property: 'og:description', content: description.to_s),
      tag('meta', name: 'theme-color', content: color)
    ].join("\n").html_safe
  end
end
