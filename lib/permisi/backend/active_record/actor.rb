# frozen_string_literal: true

module Permisi
  module Backend
    module ActiveRecord
      class Actor < ::ActiveRecord::Base
        belongs_to :aka, polymorphic: true, touch: true
        has_many :actor_roles, dependent: :destroy
        has_many :roles, through: :actor_roles

        after_commit :reset_permissions

        def role?(role_slug)
          roles.load.any? { |role| role.slug == role_slug.to_s }
        end

        def may_i?(action_path)
          PermissionUtil.allows?(permissions, action_path)
        end

        # Memoized and cached actor permissions
        def permissions
          @permissions ||= Permisi.config.cache_store.fetch(cache_key) { aggregate_permissions }
        end

        # Aggregate permissions from all roles an actor plays
        def aggregate_permissions
          roles.load.inject(HashWithIndifferentAccess.new) do |aggregate, role|
            aggregate.deep_merge(role.permissions) do |_key, effect, another_effect|
              effect == true || another_effect == true
            end
          end
        end

        def reset_permissions
          @permissions = nil
        end

        alias may? may_i?
        alias has_role? role?
      end
    end
  end
end
