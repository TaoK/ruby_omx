module RubyOmx
	DEFAULT_HOST = 'https://api.omx.ordermotion.com/hdde/xml/udi.asp'
	
	class Base
  	attr_accessor :connection

    def self.debug; @@debug ||= false end
    def self.debug=(bool); @@debug = bool end
      
    def initialize(options ={})
      @http_biz_id = options['http_biz_id']
      @udi_auth_token = options['udi_auth_token']
      raise "Must supply udi auth token" unless @udi_auth_token
      raise "Must supply http biz ID" unless @http_biz_id
      @connection = RubyOmx::Connection.connect(options)
    end
      
    def connection
      raise RubyOmx::NoConnectionEstablished.new if !connected?
      @connection
    end

    def connected?
      !@connection.nil?
    end

    def disconnect
      @connection.http.finish if @connection.persistent?
      @connection = nil
    end
      
    # Wraps the current connection's request method and picks the appropriate response class to wrap the response in.
    # If the response is an error, it will raise that error as an exception. All such exceptions can be caught by rescuing
    # their superclass, the ResponseError exception class.
    #
    # It is unlikely that you would call this method directly. Subclasses of Base have convenience methods for each http request verb
    # that wrap calls to request.
    def request(verb, body = nil, attempts = 0, &block)
        # Find the connection method in connection/management.rb which is evaled into Amazon::MWS::Base
      response = @connection.request(verb, body, attempts, &block)
        
        # Each calling class is responsible for formatting the result
      return response
    rescue InternalError, RequestTimeout
      if attempts == 3
        raise
      else
        attempts += 1
        retry
      end
    end
      
    # Make some convenience methods
    [:get, :post, :put, :delete, :head].each do |verb|
      class_eval(<<-EVAL, __FILE__, __LINE__)
        def #{verb}(body = nil, &block)
          request(:#{verb}, body, &block)
        end
      EVAL
    end
  end
end
