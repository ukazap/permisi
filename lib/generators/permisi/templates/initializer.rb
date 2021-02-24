# frozen_string_literal: true

require "permisi"

Permisi.init do |config|
  # Define which backend to use
  # See https://github.com/ukazap/permisi#configuring-backend
  config.backend = :active_record

  # Define all permissions available in the system
  # See https://github.com/ukazap/permisi#configuring-permissions
  config.permissions = {}

  # Define cache store
  # See https://github.com/ukazap/permisi#caching
  config.cache_store = Rails.cache

  # Mute pre-0.1.4 ActiveRecord backend initialization warning
  config.mute_pre_0_1_4_warning = true
end
