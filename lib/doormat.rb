require "doormat/version"
require 'doormat/module_inheritable_attributes'
require "doormat/field"

module Doormat

  def parse(data)
    fields = self.class.instance_variable_get(:@mapped_fields)
    fields.each_value do |field|
      send("#{field.to}=", field.map(data))
    end
  end

  def to_hash
    fields = self.class.instance_variable_get(:@mapped_fields)
    values = Hash.new
    fields.each_value do |field|
      values[field.to.to_sym] = send("#{field.to}")
    end
    values
  end

  def self.included(base)
    base.extend ClassMethods
    base.send :include, Doormat::ModuleInheritableAttributes
    base.send(:mattr_inheritable, :mapped_fields)
    base.instance_variable_set "@mapped_fields", {}
  end

  module ClassMethods
    def field(to, options={}, &block)
      from    = options[:source]  || to.to_s
      type    = options[:type]    || :string
      default = options[:default] || ''

      # create a getter/setter
      attr_accessor to

      # Add to class instance variable
      @mapped_fields[to] = Field.new(to, from, type, default, &block)
    end

  end

end

# rails hook app/mats dir
require 'doormat/rails' if defined?(::Rails::Engine)