# frozen_string_literal: true

module Permisi
  module Backend
    module ActiveRecord
      class Actor < ::ActiveRecord::Base
        belongs_to :aka, polymorphic: true, touch: true
        has_many :actor_roles, dependent: :destroy
        has_many :roles, through: :actor_roles

        def role?(role_slug)
          roles.load.any? { |role| role.slug == role_slug.to_s }
        end

        def may?(action_path)
          roles.load.any? { |role| role.allows?(action_path) }
        end

        alias may_i? may?
        alias has_role? role?
      end
    end
  end
end
