module Jader

  module Serialize

    module ClassMethods

      # Enable serialization on ActiveModel classes
      # @param [Array<Symbol>] args model attribute names to serialize
      # @param [Hash] args options serializing mode
      # @option args [Boolean] :merge should serialized attributes be merged with `self.attributes`
      # @example
      #     class User < ActiveRecord::Base
      #       include Jader::Serialize
      #       jade_serializable :name, :email, :merge => false
      #     end
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

    #nodoc
    def self.included(base)
      base.extend ClassMethods
    end

    # Serialize instance attributes to a Hash based on serializable attributes defined on Model class.
    # @return [Hash] hash of model instance attributes
    def to_jade
      h = {:model => self.class.name.downcase}
      self.jade_attributes.each do |attr|
        h[attr] = self.send(attr)

        ans = h[attr].class.ancestors
        if h[attr].class.respond_to?(:jade_serializable) || ans.include?(Enumerable) || ans.include?(ActiveModel::Validations)
          h[attr] = h[attr].to_jade
        else
        end
      end
      h
    end

    # List of Model attributes that should be serialized when called `to_jade` on Model instance
    # @return [Array] list of serializable attributes
    def jade_attributes
      s = self.class.class_variable_get(:@@serialize)
      if s[:merge]
        attrs = s[:attrs] + self.attributes.keys
      else
        attrs = s[:attrs]
      end
      attrs.collect{|attr| attr.to_sym}.uniq
    end
  end

end

class Object
  # Serialize Object to Jade format. Invoke `self.to_jade` if instance responds to `to_jade`
  def to_jade
    if self.respond_to? :to_a
      self.to_a.to_jade
    else
      nil
    end
  end
end

#nodoc
[FalseClass, TrueClass, Numeric, String].each do |cls|
  cls.class_eval do
    def to_jade
      self
    end
  end
end

class Array

  # Serialize Array to Jade format. Invoke `to_jade` on array members
  def to_jade
    map {|a| a.respond_to?(:to_jade) ? a.to_jade : a }
  end
end

class Hash

  # Serialize Hash to Jade format. Invoke `to_jade` on members
  def to_jade
    res = {}
    each_pair do |key, value|
      res[key] = (value.respond_to?(:to_jade) ? value.to_jade : value)
    end
    res
  end
end