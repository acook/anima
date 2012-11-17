# Main library namespace and mixin
module Anima

  # Class level resource methods
  module ClassMethods 

    # Return attribute set
    #
    # @return [AttributeSet]
    #
    # @api private
    #
    def attribute_set
      @attribute_set ||= AttributeSet.new
    end

    # Return attributes
    #
    # @param [Object] object
    #
    # @return [Hash]
    #
    # @api private
    #
    def attributes(object)
      attribute_set.each_with_object({}) do |attribute, attributes|
        attributes[attribute.name] = attribute.get(object)
      end
    end

    # Include equalizer on attributes
    #
    # @return [self]
    #
    def equalize_on_attributes
      include Equalizer.new(*attribute_set.map(&:name))
      self
    end

    # Hook called when class is inherited
    #
    # @param [Class] descendant
    #
    # @api private
    #
    def inherited(descendant)
      super

      attribute_set.each do |attribute|
        descendant.attribute_set.add(attribute)
      end

      self
    end

    # Create attribute
    #
    # @param [Symbol] name
    #
    # @return [self]
    #
    def attribute(name, klass=Attribute)
      attribute = klass.new(name)
      attribute.define_reader(self)
      attribute_set.add(attribute)

      self
    end
  end
end
