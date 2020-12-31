class Server < ApplicationRecord
  belongs_to :user

  validates :name, :description, :java_ip, :bedrock_ip, presence: true
  validates :name, length: { in: 1..64 }
  validates :name, uniqueness: { message: "A server with that name already exists!" }
  validates :description, length: { in: 100..2500 }
  validates :bedrock_ip, :java_ip, presence: true, uniqueness: true

  # Renders the description in markdown
  # @return [String] rendered markdown in HTML
  def rendered_description
    render = Redcarpet::Render::HTML.new(escape_html: true, no_images: true, no_styles: true, prettify: true)
    markdown = Redcarpet::Markdown.new(render)

    markdown.render(description)
  end

  # Gets the status of the server
  def status
    query(false) unless Rails.cache.exist? "status/#{bedrock_ip}"

    Rails.cache.fetch("status/#{bedrock_ip}")
  end

  # Queries the BEDROCK IP for its status
  # @param [Boolean]
  # @return [nil] Nothing, this is a void method
  def query(perform_later = true)
    if perform_later
      QueryServerJob.perform_later bedrock_ip
    else
      QueryServerJob.perform_now bedrock_ip
    end
    nil
  end
end
