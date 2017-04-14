# frozen_string_literal: true

module Macros
  # Base class for all the Trbr step macros
  class Base
    include Uber::Callable

    # @param args Any arguments that our macro operation supports
    # @return Single step object that can be used in operation step
    def initialize(*args)
      self.args = args
    end

    # To follow Trbr concept of named steps we have to register class instances
    # with given class names - this method registers a class so it can be used
    # with brackets. It will create a method that has a name that has the same name
    # as a class from which we want to use an object to handle a step
    #
    # @param step_name [Symbol] name that we want to use
    # @param proxy [Boolean] is this just a proxy for Trailblazer built in operation
    #
    # @example Register with :create
    #   register :create #=> Macros::Create()
    def self.register(step_name, proxy: false)
      klass = step_name.to_s.split('_').collect(&:capitalize).join

      define_singleton_method klass do |*args|
        base = "#{self}::#{klass}".constantize
        proxy ? base.new(*args).call : base.new(*args)
      end
    end

    private

    attr_accessor :args
  end
end
