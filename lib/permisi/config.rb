# frozen_string_literal: true

require "active_support/core_ext/class/attribute_accessors"

module Permisi
  class Config
    attr_reader :permissions, :default_permissions

    def initialize
      @permissions = ::HashWithIndifferentAccess.new
      @default_permissions = ::HashWithIndifferentAccess.new
    end

    def backend=(chosen_backend)
      chosen_backend = "::Permisi::Backend::#{chosen_backend.to_s.classify}".constantize if chosen_backend.is_a? Symbol
      @backend = chosen_backend
    rescue NameError
      raise Backend::InvalidBackend
    end

    def backend
      @backend || Backend::NullBackend
    end

    def permissions=(permissions_hash)
      permissions_hash = HashWithIndifferentAccess.new(permissions_hash)
      @default_permissions = PermissionUtil.transform_namespace(permissions_hash)
      @permissions = permissions_hash
    end
  end
end
