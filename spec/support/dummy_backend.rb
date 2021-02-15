require "permisi/backend/base"

class DummyBackend < Permisi::Backend::Base
  @@actors = []
  @@roles = []

  class Actor < Struct.new(:aka)
    def initialize(aka)
      super
      DummyBackend.actors << self
    end
  end

  class << self
    def reset
      @@actors = []
      @@roles = []
    end

    def actors
      @@actors
    end

    def roles
      @@roles
    end

    def findsert_actor(aka)
      Actor.new(aka)
    end
  end
end
