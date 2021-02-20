# frozen_string_literal: true

module Permisi
  module Actable
    def permisi_actor
      @permisi_actor ||= Permisi.actor(self)
    end

    alias permisi permisi_actor
  end
end
