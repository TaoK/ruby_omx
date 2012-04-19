module RubyOmx
    
    class AppendOrderResponse < Response
      xml_name "UDOAResponse"

		 	xml_reader :success, :as => Integer
		 	xml_reader :OMX
		 	xml_reader :order_number, :in => "UDOARequest/Header"
		 	xml_reader :error_data
    end
    
end
