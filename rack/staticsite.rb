module Rack
  class StaticSite 

    def initialize(options = {})
      @root = options[:root] || ::Dir.pwd
      @app  = -> env { Rack::File.new(@root).call(env) }
    end

    def call(env)
      request_env!(env)
      return render_index if root?
      build_response_for @app.call(env)
    end

    def request_env!(env)
      @request = Request.new(env)
    end

    def path_info
      @request.path_info
    end

    def root?
      path_info =~ /^\/$/
    end

    def render_index
      @index ||= response(::File.read(root("index.html")))
    end

    def not_found(env)
      @not_found ||= ::File.exists?(root("404.html")) ?
        response(::File.read(root("404.html")), 404) : env
    end

    def root(path)
      ::File.expand_path(::File.join(@root, path))
    end

    def response(content, status = 200)
      Response.new(content, status).finish
    end

    def build_response_for(env)
      env[0].to_i == 200 ? env : not_found(env)
    end

  end
end

if $0 == __FILE__
  require 'rack'
  server = Rack::Handler.default
  app = Rack::Builder.new do
    run Rack::StaticSite.new(:root => ".")
  end
  server.run app
end
