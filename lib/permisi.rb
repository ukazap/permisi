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
  end
end
