require 'small'

class LightClass
  TYPES = %w{string integer boolean fixnum float, numeric}.freeze

  def self.attribute(*args)
    options   = args.extract_options!
    attr_name = args.shift
    attributes << {attr_name.to_sym => options}
    build_instance_attrs(attr_name, options)
  end

  def self.attributes
    @attributes ||= []
  end

  def self.new(*args)
    instance = super(*args)
    instance.attributes.each do |attr|
      name, options = attr.to_a.first
      instance.send("#{name}=", options[:default]) if options[:default]
    end
    instance
  end

  class << self
    alias :property :attribute
  end
  
  def attributes
    self.class.attributes
  end
  alias :properties :attributes

  def valid?
    attributes.all? do |attr|
      name, options = attr.to_a.first
      return false unless valid_data?(name, options)
      return false unless valid_type?(name, options[:type])
      true
    end
  end

  private
  
  def valid_data?(attr, options = nil)
    return true unless options
    return send(attr).present? if options[:presence]
    return send(attr) =~ options[:regex] if options[:regex]
    true
  end

  def valid_type?(attr, type = false)
    return true unless type
    raise "Unknown type: #{type} (attribute: `#{attr}')" unless TYPES.include?(type.to_s)
    begin
      send(attr).send(:"#{type}?")
    rescue
      false
    end
  end

  def self.build_instance_attrs(arg, options)
    class_eval <<-RUBY
      def #{arg}; @#{arg}; end
      def #{arg}=(value); @#{arg}=value; end
    RUBY
    if options[:type].to_s == "boolean"
      class_eval("def #{arg}?; !!@#{arg}; end")
    end
  end

end

if $0 == __FILE__
  class Example < LightClass
    attribute :hello, :type => :string, :presence => true 
    attribute :test, :default => "hello world"
    attribute :pattern, :regex => /^\w\s\d$/
    attribute :state, :type => :boolean, :default => false
  end
  ex = Example.new
  p ex.properties
  p ex.valid?
  ex.hello = "hi"
  ex.pattern = "a 1"
  p ex.hello
  p ex.test
  p ex.state = true
  p ex.state?
  p ex.valid?
end
