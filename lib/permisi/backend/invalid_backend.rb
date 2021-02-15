module Permisi
  module Backend
    class InvalidBackend < StandardError
      def initialize(message = "Please specify a backend. For details, check https://github.com/ukazap/permisi#configuring-backend")
        super
      end
    end
  end
end
