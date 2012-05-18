class Configuration
  def initialize(&block)
    @configuration = {}
    instance_eval(&block) if block_given?
  end

  def method_missing(name, *args, &block)
    name = name.to_s.gsub(/=$/,'').to_sym
    return @configuration[name] if @configuration[name]
    return @configuration[name] = Configuration.new(&block) if block_given?
    @configuration[name] = args.shift
  end
end

