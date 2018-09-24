module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, validation, *options)
      define_method("validate_#{name}_#{validation}") do
        send(validation.to_sym, instance_variable_get("@#{name}".to_sym), *options)
      end
    end
  end

  # Module for instance methods
  module InstanceMethods
    def validate!
      public_methods.each { |method| send(method) if method =~ /^validate_/ }
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def presence(value)
      raise 'значение не может быть nil' unless value.nil? || !value.to_s.empty?
    end

    def format(value, format)
      raise 'неверный формат' if value !~ format
    end

    def type(value, class_type)
      raise 'неверный тип' unless value.class == class_type
    end
  end
end
