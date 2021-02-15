require "active_record"

module Permisi
  class Backend::ActiveRecord < Backend::Base
    class << self
      def table_name_prefix
        "permisi_"
      end

      def findsert_actor(aka)
        Actor.find_or_create_by(aka: aka)
      end

      def actors
        Actor.all
      end

      def roles
        Role.all
      end
    end
  end
end
