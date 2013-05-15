require "doormat/version"
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
    base.instance_variable_set "@mapped_fields", {}
    base.inheritable_attributes :mapped_fields
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

    def inheritable_attributes(*args)
      @inheritable_attributes ||= [:inheritable_attributes]
      @inheritable_attributes += args
      args.each do |arg|
        class_eval %(
          class << self; attr_accessor :#{arg} end
        )
      end
      @inheritable_attributes
    end

    def inherited(subclass)
      @inheritable_attributes.each do |inheritable_attribute|
        instance_var = "@#{inheritable_attribute}"
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
    end

  end

end

# rails hook app/mats dir
require 'doormat/rails' if defined?(::Rails::Engine)