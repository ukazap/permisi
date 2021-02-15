module Permisi
  class Backend::ActiveRecord::Actor < ::ActiveRecord::Base
    belongs_to :aka, polymorphic: true
    has_many :actor_roles
    has_many :roles, through: :actor_roles

    def has_role?(role_slug)
      roles.load.any? { |role| role.slug == role_slug.to_s }
    end

    def may?(action_path)
      roles.load.any? { |role| role.allows?(action_path) }
    end
  end
end
