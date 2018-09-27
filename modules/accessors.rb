module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      define_methods(name)
    end
  end

  def strong_attr_accessor(name, class_type)
    name_symbol = "@#{name}".to_sym
    define_method(name) { instance_variable_get(name_symbol) }

    define_method("#{name}=".to_sym) do |value|
      raise 'указан не верный тип' unless value.is_a?(class_type)
      instance_variable_set(name_symbol, value)
    end
  end
end

private

def define_methods(name)
  name_sym = "@#{name}".to_sym
  history_sym = "@#{name}_history".to_sym

  define_method(name) { instance_variable_get(name_sym) }

  define_method("#{name}=") do |value|
    if instance_variable_get(history_sym).nil?
      instance_variable_set(history_sym, [])
    else
      instance_variable_get(history_sym) << instance_variable_get(name_sym)
    end

    instance_variable_set(name_sym, value)
  end

  define_method("#{name}_history") { instance_variable_get(history_sym) }
end
