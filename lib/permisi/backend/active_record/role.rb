# frozen_string_literal: true

module Permisi
  module Backend
    module ActiveRecord
      class Role < ::ActiveRecord::Base
        has_many :actor_roles, dependent: :destroy
        has_many :actors, through: :actor_roles
        has_many :akas, through: :actors

        validates_presence_of :name, :slug
        validates_uniqueness_of :name, :slug

        after_initialize :set_default_permissions
        before_validation :sanitize_attributes
        after_update :touch_actor_roles

        serialize :permissions, Permisi::PermissionUtil::Serializer

        def allows?(action_path)
          Permisi::PermissionUtil.allows?(permissions, action_path)
        end

        private

        def set_default_permissions
          self.permissions ||= HashWithIndifferentAccess.new if new_record?
        end

        def sanitize_attributes
          self.name ||= slug.try(:titleize)
          self.permissions = Permisi::PermissionUtil.sanitize_permissions(self.permissions)
        end

        def touch_actor_roles
          actor_roles.each(&:touch)
        end
      end
    end
  end
end
