module Confident
  class Result
    DEFAULT_MISSING_ERROR_HANDLER_MESSAGE = "You haven't specified error handler for Confident::Result, use #on_error for that"
    DEFAULT_FAILURE_MESSAGE = "Condition should be true" 

    def initialize(value)
      @value = value
    end

    def unwrap
      unless error_handler
        raise MissingErrorHandler, DEFAULT_MISSING_ERROR_HANDLER_MESSAGE
      end
    end

    def on_error(&error_handler)
      @error_handler = error_handler
      self
    end

    private

    attr_reader :value, :error_handler

    class << self
      def ok(value=nil)
        Ok[value]
      end

      def error(value=nil)
        Error[value]
      end

      def from_condition(condition_value, failure_message=DEFAULT_FAILURE_MESSAGE)
        condition_value ? ok : error(failure_message)
      end

      def inherited(subclass)
        class << subclass; public :new, :[] end
      end

      alias_method :[], :new

      private :new, :[]
    end

    class Ok < self
      def ok?
        true
      end

      def unwrap
        super
        value
      end
    end

    class Error < self
      def ok?
        false
      end

      def unwrap
        super
        error_handler.call(value)
      end
    end

    class MissingErrorHandler < ArgumentError; end
  end
end
