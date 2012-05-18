require_relative 'html_document'
require 'faraday'

class Scraper < HTML::Document
  def self.load_from_url(url)
    @client = Faraday.new(:url =>  url)
    response = @client.get
    parse(response.body)
  end
end

if $0 == __FILE__
  class Github < Scraper
    element :title
  end

  github = Github.load_from_url("https://github.com/")
  puts github.title.text
end
