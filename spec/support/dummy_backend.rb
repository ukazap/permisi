# frozen_string_literal: true

class DummyBackend
  @actors = []
  @roles = []

  Actor = Struct.new(:aka) do
    def initialize(aka)
      super
      DummyBackend.actors << self
    end
  end

  class << self
    def reset
      @actors = []
      @roles = []
    end

    attr_reader :actors, :roles

    def findsert_actor(aka)
      Actor.new(aka)
    end
  end
end
