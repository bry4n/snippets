require 'nokogiri'
require 'delegate'

class HTML

  class Node < DelegateClass(Nokogiri::HTML::Document)

    def get(path, type = :node)
      case type
      when :html then node = at(path) and node.to_html
      when :text then node = at(path) and node.text
      else at(path)
      end
    end

  end
  
  class Document < Node
    def initialize(doc)
      super Nokogiri::HTML(doc)
    end

    def self.parse(doc)
      new(doc)
    end

    def self.element(path, options = {})
      as = options[:as] || path
      class_eval("def #{as}; at('#{path}'); end")
    end

    def self.elements(path, options = {})
      as = options[:as] || path
      class_eval("def #{as}; search('#{path}'); end")
    end

  end

end


if $0 == __FILE__

  class Example < HTML::Document
    element :title
    elements 'body > h1', :as => :message

    def full_text
      "#{title.text} + #{get(:h1, :text)}"
    end
  end

  doc = Example.parse("<html><head><title>blah</title></head><body><h1>hello</h1><h1>world</h1></body</html>")
  p doc.get(:title, :html)
  p doc.title.text
  p doc.message.map(&:text)
  p doc.full_text

end
