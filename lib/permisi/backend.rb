# frozen_string_literal: true

module Permisi
  module Backend
    class InvalidBackend < StandardError
      def initialize(message = "Please check https://github.com/ukazap/permisi#configuring-backend")
        super
      end
    end

    module NullBackend
      class << self
        def findsert_actor(_aka)
          raise InvalidBackend
        end

        def actors
          raise InvalidBackend
        end

        def roles
          raise InvalidBackend
        end
      end
    end
  end
end
