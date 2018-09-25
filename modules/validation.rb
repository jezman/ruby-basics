module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(name, validation, options = nil)
      @validations ||= []
      @validations << { name: name, type: validation, args: options }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get("@#{validation[:name]}")
        send(validation[:type].to_sym, value, validation[:args])
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def presence(value, _options)
      raise 'значение не может быть nil' unless value.nil? || !value.to_s.empty?
    end

    def format(value, format)
      raise 'неверный формат' if value !~ format
    end

    def type(value, class_type)
      raise 'неверный тип' unless value.is_a?(class_type)
    end
  end
end
