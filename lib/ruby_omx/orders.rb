module RubyOmx
  module Orders
		
		#UniversalDirectOrderAppending (UDOA200)	This request type is used to create orders in the application.
		def append_order(params ={})
			
			required_fields = [
				params[:keycode],
				params[:queue_flag],
				params[:verify_flag],
				params[:order_date],
				params[:order_id],
				params[:last_name],
				params[:line_items],
				params[:method_code],
				params[:total_amount]
			]
			#raise MissingOrderOptions if required_fields.any? {|option| option.nil?}			        
			
			raw_xml = params[:raw_xml] ||= 0

			doc = Nokogiri::XML::Document.new
			root_tag = RubyOmx.add_child_helper(doc,'UDOARequest','version','2.00',nil)
			
			udi_parameter = RubyOmx.add_child_helper(root_tag,'UDIParameter',nil,nil,nil)
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','HTTPBizID',@http_biz_id)
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','UDIAuthToken',@udi_auth_token)
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','QueueFlag',params[:queue_flag] ||= 'False')		# Determines whether any orders with errors will be stored in the OrderMotion "Outside Order Queue",  to be corrected by an OrderMotion user before resubmission. If set to "True", almost all orders will be   accepted by OrderMotion, but additional order information will only be returned in the response if the order   is successfully placed. Otherwise, any order with any error (eg invalid ZIP code) will be rejected.
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','Keycode',params[:keycode])
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','VerifyFlag',params[:verify_flag] ||= 'True')		# Determines whether a successful order should be saved, or only verified/calculated. When set to "True", OrderMotion will behave as if the order was placed, but not return an Order Number in the response.
				RubyOmx.add_child_helper(udi_parameter,'Parameter','key','Vendor',params[:vendor] ||= nil)
			
			header = RubyOmx.add_child_helper(root_tag,'Header',nil,nil,nil)
				RubyOmx.add_child_helper(header,'StoreCode',nil,nil,params[:store_code] ||= '')
				RubyOmx.add_child_helper(header,'OrderID',nil,nil,params[:order_id])
				RubyOmx.add_child_helper(header,'OrderDate',nil,nil,params[:order_date]) # Dates are almost the same as the W3C Schema "date" type, but with a space instead of the "T" separating the date from the time.
				RubyOmx.add_child_helper(header,'OriginType',nil,nil,params[:origin_type] ||= '2') # 2 = phone order, 3 = internet order
			
			customer = RubyOmx.add_child_helper(root_tag,'Customer',nil,nil,nil)			
				address = RubyOmx.add_child_helper(customer,'Address','type','BillTo',nil)
					RubyOmx.add_child_helper(address,'TitleCode',nil,nil,params[:title_code] ||= '0')
					RubyOmx.add_child_helper(address,'Firstname',nil,nil,params[:first_name] ||= 'Test')
					RubyOmx.add_child_helper(address,'Lastname',nil,nil,params[:last_name] ||= 'Test')
					RubyOmx.add_child_helper(address,'Address1',nil,nil,params[:address1] ||= nil)
					RubyOmx.add_child_helper(address,'Address2',nil,nil,params[:address2] ||= nil)
					RubyOmx.add_child_helper(address,'City',nil,nil,params[:city] ||=nil)
					RubyOmx.add_child_helper(address,'State',nil,nil,params[:state] ||= nil)
					RubyOmx.add_child_helper(address,'ZIP',nil,nil,params[:zip] ||=nil)
					RubyOmx.add_child_helper(address,'TLD',nil,nil,params[:tld] ||=nil)
					RubyOmx.add_child_helper(address,'PhoneNumber',nil,nil,params[:phone] ||= nil)
					RubyOmx.add_child_helper(address,'Email',nil,nil,params[:email] ||= nil)
						
			shipping_info = RubyOmx.add_child_helper(root_tag,'ShippingInformation',nil,nil,nil)
				RubyOmx.add_child_helper(shipping_info,'MethodCode',nil,nil,params[:method_code])
			#	address = RubyOmx.add_child_helper(shipping_info,'Address','type','ShipTo',nil)
			#		RubyOmx.add_child_helper(address,'TitleCode',nil,nil,'0')
			#		RubyOmx.add_child_helper(address,'Firstname',nil,nil,'Test') #TODO capture the first and last name for billing, not just shipping
			#		RubyOmx.add_child_helper(address,'Lastname',nil,nil,'Test')
			#		RubyOmx.add_child_helper(address,'Address1',nil,nil,'251 West 30th St')
			#		RubyOmx.add_child_helper(address,'Address2',nil,nil,'Apt 12E')
			#		RubyOmx.add_child_helper(address,'City',nil,nil,'New York')
			#		RubyOmx.add_child_helper(address,'State',nil,nil,'NY')
			#		RubyOmx.add_child_helper(address,'ZIP',nil,nil,'10001')
			#		RubyOmx.add_child_helper(address,'TLD',nil,nil,'US')
				#	RubyOmx.add_child_helper(address,'PhoneNumber',nil,nil,nil)
				#	RubyOmx.add_child_helper(address,'Email',nil,nil,nil)
				RubyOmx.add_child_helper(shipping_info,'ShippingAmount',nil,nil,params[:shipping_amount] ||= '0.00')		
				#RubyOmx.add_child_helper(shipping_info,'HandlingAmount',nil,nil,'0')		
				#RubyOmx.add_child_helper(shipping_info,'SpecialInstructions',nil,nil,'0')
				RubyOmx.add_child_helper(shipping_info,'GiftWrapping',nil,nil,params[:gift_wrapping] ||= 'False')								
				RubyOmx.add_child_helper(shipping_info,'GiftMessage',nil,nil,params[:gift_message] ||= nil)				
							
			payment_type = RubyOmx.add_child_helper(root_tag,'Payment','type',params[:payment_type] ||= '6',nil) #6 for open invoice
			#	RubyOmx.add_child_helper(payment_type,'CardNumber',nil,nil,'4111111111111111')
			#	RubyOmx.add_child_helper(payment_type,'CardVerification',nil,nil,'222')
			#	RubyOmx.add_child_helper(payment_type,'CardExpDateMonth',nil,nil,'09')
			#	RubyOmx.add_child_helper(payment_type,'CardExpDateYear',nil,nil,'2011')
			#	RubyOmx.add_child_helper(payment_type,'CardStatus',nil,nil,'11')
			#	RubyOmx.add_child_helper(payment_type,'CardAuthCode',nil,nil,'11')
			#	RubyOmx.add_child_helper(payment_type,'CardTransactionID',nil,nil,'123456789')
				
			order_detail = RubyOmx.add_child_helper(root_tag,'OrderDetail',nil,nil,nil)
				
				i=1
				params[:line_items].each do |item|
					raise MissingItemOptions if item[:item_code].nil?
					line_item = RubyOmx.add_child_helper(order_detail,'LineItem','lineNumber',i.to_s,nil) 	
						RubyOmx.add_child_helper(line_item,'ItemCode',nil,nil,item[:item_code])
						RubyOmx.add_child_helper(line_item,'Quantity',nil,nil,item[:quantity] ||= '1')
						if !item[:unit_price].nil?
							RubyOmx.add_child_helper(line_item,'UnitPrice',nil,nil,item[:unit_price])
						end
						#RubyOmx.add_child_helper(line_item,'StandingOrder','configurationID','5',nil)
						#customization = RubyOmx.add_child_helper(line_item,'ItemCustomizationData',nil,nil,nil)
						#field = RubyOmx.add_child_helper(customization,'CustomizationField','fieldID','127',nil)
						#RubyOmx.add_child_helper(field,'Value',nil,nil,'demoText')
						i+=1
				end
			
			check = RubyOmx.add_child_helper(root_tag,'Check',nil,nil,nil)
			RubyOmx.add_child_helper(check,'TotalAmount',nil,nil,params[:total_amount])
								    
      response = post(doc.to_xml)
      if raw_xml==1
      	return response
      else
       	AppendOrderResponse.format(response)
      end
    end
    
    #OrderDetailUpdateRequest (ODUR100)	This request type enables you to update certain data for orders.
    
    
		#CancellationHistoryRequest (CHR100)	This request type lists all the cancellations that have occurred between two dates.
		#InvoiceProcessRequest (IPR100)	This command takes an order number, and runs the invoicing and credit memo processes against the order if there are any order lines that can be subject to an invoice or credit memo, or if there are returns on the order.
		#OrderCancellationRequest (OCR100)	This request type enables you to cancel some or all the line items in an order.		
		#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.
		#OrderSecondaryStatusUpdateRequest (OSSUR100)	This request type enables you to set the secondary status of the OrderLines.
		#OrderUpdateRequest (OUR200)	This request type enables you to change the Payment Plan of an order, as well as the basis date for payment plan calculation, and also update the "Alt ID 2" (a.k.a "Reference") field of the order.
		#OrderWaitDateUpdateRequest (OWDUR100)	This request type enables you to change the Wait Date of an existing order.  
  end
end
