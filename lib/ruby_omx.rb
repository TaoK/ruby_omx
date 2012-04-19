#require 'rubygems'
require 'cgi'
require 'uri'
require 'openssl'
require 'net/https'
require 'time'
require 'date'
require 'base64'
require 'builder'
require "rexml/document"
require 'roxml'

$:.unshift(File.dirname(__FILE__))

module RubyOmx
	
	module_function
	def add_child_helper(parent_node,child_name,key,value,content)
		new_node = parent_node.add_child(Nokogiri::XML::Node.new child_name, parent_node)
		if !key.nil? && !value.nil?
			new_node[key] = value
		end
		if !content.nil?
			new_node.content = content
		end
		return new_node			
	end
	
end

require 'ruby_omx/response'
require 'ruby_omx/orders'
require 'ruby_omx/items'
Dir.glob(File.join(File.dirname(__FILE__), 'ruby_omx/response/*.rb')).each {|f| require f }

require 'ruby_omx/base'
require 'ruby_omx/version'
require 'ruby_omx/exceptions'
require 'ruby_omx/connection'

RubyOmx::Base.class_eval do
  include RubyOmx::Orders
  include RubyOmx::Items
end