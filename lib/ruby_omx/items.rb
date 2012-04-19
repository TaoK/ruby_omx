module RubyOmx
  module Items

		# ItemInformationRequest (ITIR100)	This request type lists the name, default prices, inventory availability, sub-items, cross-sell items, substitution items, and bundle items for a given item code.			
		def get_item_info(params ={})
			required_fields = [
				params[:item_code]
			]
			raise MissingOrderOptions if required_fields.any? {|option| option.nil?}
			item_code = params[:item_code]
			raw_xml = params[:raw_xml] ||= 0
					
			doc = Nokogiri::XML::Document.new
			root_tag = RubyOmx.add_child_helper(doc,'ItemInformationRequest','version','1.00',nil)
			udi_parameter = RubyOmx.add_child_helper(root_tag,'UDIParameter',nil,nil,nil)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','HTTPBizID',@http_biz_id)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','ItemCode',item_code)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','OutputSubItemAttributes','True')
      response = post(doc.to_xml)
      if raw_xml==1
      	return response
      else
      	ItemInfoResponse.format(response)
      end
    
    end

		#CustomItemAttributeInformationRequest (CIAIR200)	This request type lists all the custom item attributes names and values for a given item code or list of item codes, in one or all custom item attribute groups.
		def get_custom_item_info(params ={})
			required_fields = [
				params[:item_code]
			]
			raise MissingOrderOptions if required_fields.any? {|option| option.nil?}
			item_code = params[:item_code]
			raw_xml = params[:raw_xml] ||= 0
		
			doc = Nokogiri::XML::Document.new
			root_tag = RubyOmx.add_child_helper(doc,'CustomItemAttributeInformationRequest','version','2.00',nil)
			udi_parameter = RubyOmx.add_child_helper(root_tag,'UDIParameter',nil,nil,nil)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','HTTPBizID',@http_biz_id)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','ItemCode',item_code)
			RubyOmx.add_child_helper(udi_parameter,'Parameter','key','AttributeGroupID','All')
      response = post(doc.to_xml)
      if raw_xml==1
      	return response
      else
      	ItemInfoResponse.format(response)
      end
		end
		
		#CustomItemAttributeUpdateRequest (CIAUR100)	This request type is used to set or update the custom item attribute values for a given item code.
		#ItemCategoryUpdateRequest (ITCATUR100)	This request type is used to set the categories for an item. Categories can be used as the basis for webstore sections, or other classification needs in the application.
		#ItemCustomizationGroupAssignmentRequest (ICGAR200)	This request type allows for assigning a shared customization group to an item, by name or by ID.
		#ItemCustomizationGroupUpdateRequest (ICGUR200)	This request type is used to update shared item customization groups in the account.
		#ItemCustomizationUpdateRequest (ICUR200)	This request type is used to add and update individual item customizations by item, rather than shared customization groups.
		#ItemListRequest (ILR100)	This command returns a list of items.
		#ItemLocationUpdateRequest (ILUR100)	This command enables you to update item location information.
		#ItemLocatorRequest (ITLR100)	This request type lists possible matches for an item given search information.
		#ItemPriceUpdateRequest (IPUR100)	This request type is used to update item default prices or keycode prices.
		#ItemUpdateRequest (ITUR200)	This command enables you to create items, or update item information (with selective partial updates).
		#LocationUpdateRequest (LUR100)	This command enables you to update location information.
		#SubItemUpdateRequest (SITUR100)	This request type is used to update parent/sub-item associations, or to create new sub-items for a given parent item.
		#SupplierItemUpdateRequest (SUPITUR100)	This request type is used to create or update a supplier-item association.
    
  end
end
