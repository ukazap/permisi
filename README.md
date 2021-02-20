If you're viewing this at https://github.com/ukazap/permisi, you're reading the documentation for the main branch. [Go to specific version.](https://github.com/ukazap/permisi/tags)

<table>
  <tr>
    <th>
      <a href="https://commons.wikimedia.org/wiki/File:Female_Chinese_Lion_Statue.jpg">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Female_Chinese_Lion_Statue.jpg/102px-Female_Chinese_Lion_Statue.jpg">
      </a>
    </th>
    <th>
      <h1>Permisi</h1>
      <p><em>Simple and dynamic role-based access control for Rails</em></p>
      <p>
        <a href="https://badge.fury.io/rb/permisi">
          <img src="https://badge.fury.io/rb/permisi.svg" alt="Gem Version">
        </a>
        <a href="https://codeclimate.com/github/ukazap/permisi/maintainability">
          <img src="https://api.codeclimate.com/v1/badges/0b1238302f2012b20740/maintainability" />
        </a>
        <a href="https://codecov.io/gh/ukazap/permisi">
          <img src="https://codecov.io/gh/ukazap/permisi/branch/main/graph/badge.svg?token=9YRMVFCDA8"/>
        </a>
      </p>
    </th>
    <th>
      <a href="https://commons.wikimedia.org/wiki/File:Male_Chinese_Lion_Statue.jpg">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Male_Chinese_Lion_Statue.jpg/98px-Male_Chinese_Lion_Statue.jpg">
      </a>
    </th>
  </tr>
</table>

## Concept

Permisi provides a way of dynamically declaring user rights (a.k.a. permissions) using a simple role-based access control scheme.

This is not an alternative to CanCanCan/Pundit, instead it complement them with dynamic role definition and role membership.

Permisi has three basic concepts:

- Actor: a person, group of people, or an automated agent who interacts with the app
- Role: a job function, job title, or rank which determines an actor's authority
- Permission: the ability to perform an action

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'permisi'
```

And then execute:

    $ bundle install
    $ rails g permisi:install

## Configuring backend

Set `config.backend` in the initializer to the backend of choice for storing and retrieving roles:

```ruby
# config/initializers/permisi.rb

Permisi.init do |config|
  #...
  config.backend = :active_record
  #...
end
```

To use `:active_record`, run the generated migration from the installation step:

    $ rails db:migrate

Permisi only support `:active_record` backend at the moment. In the future, it will be possible to use `:mongoid`.

## Configuring permissions

First you have to predefine the permissions, which is basically a set of possible actions according to the app's use cases. The actions can be grouped in any way possible. For example, you might want to define actions around resource types.

To define the available actions in the system, assign a hash to the `config.permissions` with the following format:

```ruby
# config/initializers/permisi.rb
Permisi.init do |config|
  # ...
  config.permissions = {
    # A symbol-array pair denotes a namespace.
    # A common use of namespacing is for grouping
    # available actions by resources.
    authors: [
      # Enclosed in the array are symbols
      # denoting available actions in the namespace:
      :list,
      :view,
      :create,
      :edit,
      :delete
    ],
    # You can also use the simplified %i[] notation:
    publishers: %i[list view create edit delete],
    # Besides actions, you can also have nested
    # namespaces:
    books: [
      :list,
      :view,
      :create,
      :edit,
      :delete,
      {
        editions: [
          :list, :view, :create, :edit, :delete, :archive
        ]
      }
    ]
  }
  # ...
end
```

## Defining and managing roles

Once you have the predefined permissions, you can then define different roles with different level of access within the boundary of the predefined permissions. You can delete or create new roles according to organizational changes. You can also modify existing roles without a change in your code.

You can create, edit, and destroy roles at runtime. You might also want to define preset roles via `db/seeds.rb`.

```ruby
# Interact with Permisi.roles as you would with ActiveRecord query interfaces:

# List all roles
Permisi.roles.all

# Create a new role
admin_role = Permisi.roles.create(slug: :admin, name: "Administrator", permissions: {
  books: {
    list: true,
    view: true,
    create: true,
    edit: true
  }
})

# Ask specific role permission
admin_role.allows? "books.delete" # == false

# Update existing role
admin.permissions[:books].merge!({ delete: true })
admin.save
admin_role.allows? "books.delete" # == true
```

## Configuring actors

You can then give or take multiple roles to an actor which will allow or prevent them to perform certain actions in a flexible manner. But before you can do that, you have to wire up your user model with Permisi using via `Permisi::Actable` mixin.

Permisi does not hold an assumption that a specific model is present (e.g. User model). Instead, it keeps track of "actors" internally. The goal is to support multiple use cases such as actor polymorphism, user _groups_, etc.

For example, you can map your user model to Permisi's actor model like so:

```ruby
# app/models/user.rb

class User < ApplicationRecord
  include Permisi::Actable
end
```

You can then interact using `#permisi` method:

```ruby
user = User.find_by_email "esther@example.com"
user.permisi # => instance of Actor

admin_role = Permisi.roles.find_by_slug(:admin)
admin_role.allows? "books.delete" # == true

user.permisi.roles << admin_role

user.permisi.role? :admin # == true
user.permisi.has_role? :admin # == user.permisi.role? :admin

user.permisi.may_i? "books.delete" # == true
user.permisi.may? "books.delete" # == user.permisi.may_i? "books.delete"

user.permisi.roles.destroy(admin_role)

user.permisi.role? :admin # == false
user.permisi.may_i? "books.delete" # == false
```

## Contributing

For development and how to submit improvements, please refer to the [contribution guide](https://github.com/ukazap/permisi/blob/main/CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Permisi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ukazap/permisi/blob/main/CODE_OF_CONDUCT.md).
