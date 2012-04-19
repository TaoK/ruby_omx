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

require 'RubyOmx/response'
require 'RubyOmx/orders'
require 'RubyOmx/items'
Dir.glob(File.join(File.dirname(__FILE__), 'RubyOmx/response/*.rb')).each {|f| require f }

require 'RubyOmx/base'
require 'RubyOmx/version'
require 'RubyOmx/exceptions'
require 'RubyOmx/connection'

RubyOmx::Base.class_eval do
  include RubyOmx::Orders
  include RubyOmx::Items
end

#require_library_or_gem 'xmlsimple', 'xml-simple' unless defined? XmlSimple