require "active_support/core_ext/class/attribute_accessors"

module Permisi
  class Config
    attr_accessor :backend, :permissions
    attr_reader :default_permissions

    def initialize
      @permissions = ::HashWithIndifferentAccess.new
    end

    def backend=(chosen_backend)
      if chosen_backend.is_a? Symbol
        chosen_backend = "::Permisi::Backend::#{chosen_backend.to_s.classify}".constantize
      end

      @backend = chosen_backend
    end

    def permissions=(hash)
      hash = HashWithIndifferentAccess.new(hash) unless hash.is_a?(HashWithIndifferentAccess)
      @default_permissions = PermissionUtil.transform_namespace(@permissions)
      @permissions = hash
    end
  end
end
