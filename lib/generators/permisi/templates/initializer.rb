require "permisi"

Permisi.init do |config|
  # Define which backend to use
  # See https://github.com/ukazap/permisi#configuring-backend
  config.backend = :active_record

  # Define all permissions available in the system
  # See https://github.com/ukazap/permisi#configuring-permissions
  config.permissions = {}
end
