# frozen_string_literal: true

require "zeitwerk"
$permisi_loader = Zeitwerk::Loader.for_gem
$permisi_loader.ignore("#{__dir__}/generators")
$permisi_loader.ignore("#{__dir__}/permisi/backend/mongoid.rb") # todo
$permisi_loader.setup

module Permisi
  class << self
    def init(&block)
      yield config if block_given?
    end

    def config
      @@config ||= Config.new
    end

    def actors
      __backend.actors
    end

    def actor(aka)
      __backend.findsert_actor(aka)
    end

    def roles
      __backend.roles
    end

    private

    def __backend
      if config.backend.nil? || !(config.backend <= Backend::Base)
        raise Backend::InvalidBackend
      end

      config.backend
    end
  end
end
