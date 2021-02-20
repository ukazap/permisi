# frozen_string_literal: true

module Permisi
  module PermissionUtil
    class InvalidNamespace < StandardError; end

    class << self
      def allows?(hash, action_path)
        return false unless hash.is_a?(Hash)

        action_path_arr = action_path.split(".")
        begin
          !Permisi.config.default_permissions.dig(*action_path_arr).nil?
        rescue StandardError
          false
        end &&
          hash.dig(*action_path_arr) == true
      end

      def transform_namespace(namespace, current_path: nil)
        HashWithIndifferentAccess.new.tap do |transformed|
          namespace.each_pair do |key, value|
            unless value.is_a? Array
              raise InvalidNamespace,
                    "`#{[current_path, key].compact.join(".")}` should be an array"
            end

            value.each.with_index do |arr_v, arr_i|
              case arr_v
              when Symbol
                transformed[key] ||= ::HashWithIndifferentAccess.new
                if transformed[key].key? arr_v
                  raise InvalidNamespace, "duplicate entry: `#{[current_path, key, arr_v].compact.join(".")}`"
                end

                transformed[key][arr_v] = false
              when Hash
                transform_namespace(arr_v,
                                    current_path: [current_path, key].compact.join(".")).each_pair do |ts_k, ts_v|
                  transformed[key] ||= ::HashWithIndifferentAccess.new
                  if transformed[key].key? ts_k
                    raise InvalidNamespace, "duplicate entry: `#{[current_path, key, ts_k].compact.join(".")}`"
                  end

                  transformed[key][ts_k] = ts_v
                end
              else
                raise InvalidNamespace,
                      "`#{[current_path, key].compact.join(".")}[#{arr_i}]` should be a symbol or a hash"
              end
            end
          end
        end
      end

      def sanitize_permissions(permission_hash)
        __deeply_sanitize_permissions(permission_hash, template: Permisi.config.default_permissions)
      end

      private

      def __deeply_sanitize_permissions(permission_hash, template: {})
        HashWithIndifferentAccess.new.tap do |sanitized|
          permission_hash.each_pair do |key, value|
            next unless template.key?(key)

            sanitized[key] = if value.is_a?(Hash)
                               __deeply_sanitize_permissions(value, template: template[key])
                             else
                               __cast_value_to_boolean(value)
                             end
          end
        end
      end

      def __cast_value_to_boolean(value)
        bool = ActiveModel::Type::Boolean.new.cast(value)
        bool ||= false
      end
    end

    class Serializer
      def self.dump(hash)
        hash
      end

      def self.load(hash)
        (hash.is_a?(Hash) ? hash : {}).with_indifferent_access
      end
    end
  end
end
