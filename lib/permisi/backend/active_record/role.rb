module Permisi
  class Backend::ActiveRecord::Role < ::ActiveRecord::Base
    has_many :actor_roles
    has_many :actors, through: :actor_roles
    has_many :akas, through: :actors

    validates_presence_of :name, :slug
    validates_uniqueness_of :name, :slug

    after_initialize :set_default_permissions
    before_validation :sanitize_permissions

    serialize :permissions, Permisi::PermissionUtil::Serializer

    def allows?(action_path)
      Permisi::PermissionUtil.allows?(self.permissions, action_path)
    end

    def set_default_permissions
      self.permissions ||= Permisi.config.default_permissions if self.new_record?
    end

    def sanitize_permissions
      self.permissions = Permisi::PermissionUtil.sanitize_permissions(self.permissions)
    end
  end
end
