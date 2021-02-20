# How to contribute

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ukazap/permisi/blob/master/CODE_OF_CONDUCT.md).

## Found a bug?

- Search the [issues labeled "bug"](https://github.com/ukazap/permisi/issues?q=is%3Aissue+label%3Abug) to see if it's already reported.
- Make sure you are using the latest version of Permisi [![Gem Version](https://badge.fury.io/rb/permisi.svg)](https://badge.fury.io/rb/permisi)
- If you are still having an issue, create an issue including:
  - Ruby version
  - Gemfile.lock contents or at least major gem versions, such as Rails version
  - Steps to reproduce the issue
  - Full backtrace for any errors encountered

## Submitting changes

If you want to contribute an enhancement or a fix:

- Fork the project on GitHub
- After checking out the repo, run `bin/setup` to install dependencies
- Make your changes with tests
- Run `bundle exec rubocop -A` to auto-format your code
- Run `rake spec` to run the tests
- Commit the changes without making changes to the Rakefile or any other files that aren't related to your enhancement or fix
- Send a pull request
