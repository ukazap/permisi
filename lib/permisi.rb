# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Permisi
  class << self
    def init(&block)
      yield config if block_given?
    end

    def config
      @@config ||= Config.new
    end
  end
end
