require "doormat/version"
require "doormat/field"

module Doormat

  def parse(data)
    fields = self.class.instance_variable_get(:@mapped_fields)
    fields.each_value do |field|
      send("#{field.to}=", field.map(data))
    end

  end

  def self.included(base)
    base.instance_variable_set(:@mapped_fields, {})
    base.extend ClassMethods
  end

  module ClassMethods
    def field(to, options={}, &block)
      from    = options[:source]  || to.to_s
      type    = options[:type]    || :string
      default = options[:default] || ''

      # create a getter/setter
      attr_accessor to

      # Add to class instace variable
      @mapped_fields[to] = Field.new(to, from, type, default, &block)
    end
  end

end

# rails hook app/mats dir
require 'doormat/rails' if defined?(::Rails::Engine)