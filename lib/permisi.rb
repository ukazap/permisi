# frozen_string_literal: true

require "active_model/type"
require "active_support"
require "zeitwerk"

module Permisi
  LOADER = Zeitwerk::Loader.for_gem

  class << self
    def init
      yield config if block_given?
    end

    def config
      @config ||= Config.new
    end

    def actors
      config.backend.actors
    end

    def actor(aka)
      config.backend.findsert_actor(aka)
    end

    def roles
      config.backend.roles
    end
  end
end

Permisi::LOADER.ignore("#{__dir__}/generators")
Permisi::LOADER.ignore("#{__dir__}/permisi/backend/mongoid.rb") # todo
Permisi::LOADER.setup
