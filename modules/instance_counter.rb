module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :count

    def instances
      self.count ||= 0
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.count = self.class.instances + 1
    end
  end
end
