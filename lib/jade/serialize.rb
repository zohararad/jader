module Jade

  module Serialize

    module ClassMethods

      def jade_serializable(*args)
        serialize = {
          :attrs => [],
          :merge => true
        }
        args.each do |arg|
          if arg.is_a? Symbol
            serialize[:attrs] << arg
          elsif arg.is_a? Hash
            serialize[:merge] = arg[:merge] if arg.include?(:merge)
          end
        end
        class_variable_set(:@@serialize, serialize)
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end

    def jade_attributes
      s = self.class.class_variable_get(:@@serialize)
      if s[:merge]
        attrs = s[:attrs] + self.attributes.keys
      else
        attrs = s[:attrs]
      end
      attrs.collect{|attr| attr.to_sym}.uniq
    end

    def to_jade
      h = {}
      self.jade_attributes.each do |attr|
        h[attr] = self.send(attr)
      end
      h
    end

  end

end

class Object
  def to_ice
    if self.respond_to? :to_a
      self.to_a.to_jade
    else
      nil
    end
  end
end

[FalseClass, TrueClass, Numeric, String].each do |cls|
  cls.class_eval do
    def to_jade
      self
    end
  end
end

class Array
  def to_jade
    map {|a| a.respond_to?(:to_jade) ? a.to_jade : a }
  end
end

class Hash
  def to_jade
    res = {}
    each_pair do |key, value|
      res[key] = (value.respond_to?(:to_jade) ? value.to_jade : value)
    end
    res
  end
end