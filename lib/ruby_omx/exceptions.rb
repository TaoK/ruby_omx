module RubyOmx
    
  # Abstract super class of all Amazon::MWS exceptions
  class RubyOmxException < StandardError
  end
    
  # Abstract super class for all invalid options.
  class InvalidOption < RubyOmxException
  end
    
  class InvalidMessageType < RubyOmxException
  end
    
  class InvalidReportType < RubyOmxException
  end
    
  class InvalidSchedule < RubyOmxException
  end
    
  class MissingConnectionOptions < RubyOmxException
  end
  
  class MissingOrderOptions < RubyOmxException
  end
  
  class MissingItemOptions < RubyOmxException
  end
    
  # All responses with a code between 300 and 599 that contain an <Error></Error> body are wrapped in an
  # ErrorResponse which contains an Error object. This Error class generates a custom exception with the name
  # of the xml Error and its message. All such runtime generated exception classes descend from ResponseError
  # and contain the ErrorResponse object so that all code that makes a request can rescue ResponseError and get
  # access to the ErrorResponse.
  # class ResponseError < RubyOmxException
  #   def initialize(formatted_response)
  #     instance_eval(<<-EVAL, __FILE__, __LINE__)
  #       def request_id
  #         '#{formatted_response["RequestID"]}'
  #       end
  #     EVAL
  #     
  #     formatted_response["Error"].each do |key, value|
  #       instance_eval(<<-EVAL, __FILE__, __LINE__)
  #         def #{key.underscore}
  #           '#{value}'
  #         end
  #       EVAL
  #     end
  #   end
  # end
    
  class RequestTimeout < ResponseError
  end
    
  # Most ResponseError's are created just time on a need to have basis, but we explicitly define the
  # InternalError exception because we want to explicitly rescue InternalError in some cases.
  class InternalError < ResponseError
  end
    
  # Raised if an unrecognized option is passed when establishing a connection.
  class InvalidConnectionOption < InvalidOption
    def initialize(invalid_options)
      message = "The following connection options are invalid: #{invalid_options.join(', ')}. "    +
                "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
      super(message)
    end
  end
    
  # Raised if either the access key id or secret access key arguments are missing when establishing a connection.
  class MissingAccessKey < InvalidOption
    def initialize(missing_keys)
      key_list = missing_keys.map {|key| key.to_s}.join(' and the ')
      super("You did not provide both required access keys. Please provide the #{key_list}.")
    end
  end
    
  # Raised if a request is attempted before any connections have been established.
  class NoConnectionEstablished < RubyOmxException
    def initialize
      super("\nPlease use Amazon::MWS::Base.establish_connection! before making API calls.")
    end
  end
        
end