module RubyOmx
     
  class Connection
    # Static/Class methods
    class << self
      def connect(options = {})
        new(options)
      end
    end
      
    def initialize(params = {})
      
      # These values are essential to establishing a connection
      @udi_auth_token   = params['udi_auth_token']
      @server           = params['server'] || RubyOmx::DEFAULT_HOST + "?UDIAuthToken=#{@udi_auth_token}"
      @persistent       = params['persistent'] || false
      @http_biz_id 			= params['http_biz_id']
			@path = URI.parse(@server).request_uri
        
      raise MissingConnectionOptions if [@udi_auth_token, @http_biz_id].any? {|option| option.nil?}
      @http = connect
    end
      
    # Create the Net::HTTP object to use for this connection
    def connect
      uri 							= URI.parse(@server)
      http             	= Net::HTTP.new(uri.host, uri.port)
      http.use_ssl  	  = true
      http.verify_mode 	= OpenSSL::SSL::VERIFY_NONE
      return http
    end
      
    # Make the request, based on the appropriate request object
    # Called from RubyOmx::Base
    def request(verb, body = nil, attempts = 0, &block)
      request = Net::HTTP.const_get(verb.to_s.capitalize).new(@path, {'User-Agent' => 'ruby_omx ' + RubyOmx::VERSION})
      request.body = body
      request.content_length = request.body.size
			request.content_type = "text/xml; charset=utf-8"
      @http.request(request)
      
    rescue Errno::EPIPE, Timeout::Error, Errno::EINVAL, EOFError
      @http = connect
      attempts == 3 ? raise : (attempts += 1; retry)
    end
     
  end
end

