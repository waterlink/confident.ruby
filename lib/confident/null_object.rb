module Confident
  class NullObject
    def method_missing(*)
      self
    end
  end

  module AutoNullObject
    class << self
      def wrap(value)
        return value unless NilClass === value
        NullObject.new
      end

      alias_method :[], :wrap
    end
  end
end
