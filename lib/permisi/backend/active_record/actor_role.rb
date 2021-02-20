# frozen_string_literal: true

module Permisi
  module Backend
    module ActiveRecord
      class ActorRole < ::ActiveRecord::Base
        belongs_to :actor, touch: true
        belongs_to :role

        after_destroy :touch_actor

        private

        def touch_actor
          actor.touch
        end
      end
    end
  end
end
