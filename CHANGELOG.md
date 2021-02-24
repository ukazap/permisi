# Changelog

# 0.1.5

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.5/README.md)

- Remove `-> { distinct }` from actor-roles has_many association
- Add option to mute pre-0.1.4 ActiveRecord backend initialization warning:

  ```ruby
  # config/initializers/permisi.rb

  Permisi.init do |config|
    # Mute pre-0.1.4 ActiveRecord backend initialization warning
    config.mute_pre_0_1_4_warning = true
  end
  ```

# 0.1.4

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.4/README.md)

- Add actor-role uniqueness constraint (previously it was possible to append the same role to an actor many times), if you are upgrading from previous versions, please create the following migration: `add_index :permisi_actor_roles, [:actor_id, :role_id], unique: true`
- Show warning when calling "roles.delete" because it won't invalidate the cache

# 0.1.3

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.3/README.md)

- Correct grammars and examples in the docs
- Change actor permissions cache key

# 0.1.2

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.2/README.md)

- Fix namespaces/actions should no longer contain periods
- Implement cache config for faster access to actor permissions

# 0.1.1

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.1/README.md)

- General code refactoring
- Improvements on ActiveRecord backend:
  - Code refactoring
  - Implement cache invalidation

# 0.1.0

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.1.0/README.md)

Finished extraction work from my past projects.

- Implement ActiveRecord backend
- Implement `Actable` mixin
- Implement permissions hash sanitization and checking

# 0.0.1

[_View the docs._](https://github.com/ukazap/permisi/blob/v0.0.1/README.md)

Reserved the gem name: https://en.wiktionary.org/wiki/permisi
