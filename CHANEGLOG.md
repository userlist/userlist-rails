# Userlist for Ruby on Rails Changelog

## v0.6.1 (2021-05-14)

- Upgrades dependencies

## v0.6.0 (2021-05-14)

- Improves handling of relationships across different setups (1:1, 1:n, and n:m)
- Automatically call userlist_* methods on models in transforms

## v0.5.3 (2021-04-15)

- Makes userlist_push? and userlist_delete? methods work as documented

## v0.5.2 (2021-02-12)

- Only detect classes as models

## v0.5.1 (2021-01-22)

- Adds deprecation warnings for user and company models
- Adds documentation about tracking companies and relationships

## v0.5.0 (2021-01-22)

- Adds support for relationships between users and companies
- Allows setting of global company for events
- Improves reliablity of callback initializations
- Don’t extend the user and company model anymore
- Log errors when pushing instead of raising them
- Introduced transforms to wrap models as payloads
- Replaces userlist.io with userlist.com
- Require at least Ruby 2.3
- Upgrades dependencies

## v0.4.0 (2020-03-10)

- Adds helper method for adding the Userlist script tag
- Require at least Ruby 2.3

## v0.3.0 (2019-06-27)

- Use Userlist::Push::Resources to transform payloads
- Upgrades dependencies


## v0.2.2 (2019-03-18)

- Adds support for Ruby 2.2

## v0.2.1 (2019-03-13)

- Use an explicit method for callbacks instead of just a block
- Adds note about test and development environments

## v0.2.0 (2018-11-21)

- Adds basic documentation
- Adds support for global defintion of current user
- Use created_at as signed_up_at for users
- Use global push instance instead of creating one for each model
- Properly prepare models in rake tasks
- Properly setup models after reloads
- Upgrades dependencies

## v0.1.0 (2018-01-18)

- Initial release
