# Userlist::Rails [![Build Status](https://travis-ci.com/userlistio/userlist-rails.svg?branch=master)](https://travis-ci.com/userlistio/userlist-rails)

This gem helps with integrating [Userlist.io](http://userlist.io) into Ruby on Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'userlist-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install userlist-rails

## Configuration

The only required configuration is the Push API key. You can get your Push API key via the [Push API settings](https://app.userlist.io/settings/push) in your Userlist.io account.

Configuration values can either be set via an initializer or as environment variables. The environment take precedence over configuration values from the initializer. Please refer to the [userlist-ruby](http://github.com/userlistio/userlist-ruby) gem for additional configuration options.

Configuration via environment variables:

```shell
USERLIST_PUSH_KEY=401e5c498be718c0a38b7da7f1ce5b409c56132a49246c435ee296e07bf2be39
```

Configuration via an initializer:

```ruby
# config/initializer/userlist.rb
Userlist.configure do |config|
  config.push_key = '401e5c498be718c0a38b7da7f1ce5b409c56132a49246c435ee296e07bf2be39'
end
```

### Disabling in development and test environments

As sending test and development data into data into Userlist isn't very desireable, you can disable transmissions by setting the push strategy to `:null`.

```ruby
# config/initializer/userlist.rb
Userlist.configure do |config|
  config.push_strategy = :null unless Rails.env.production?
end
```


## Usage

### Tracking Users

#### Sending user data automatically

By default, this gem will automatically detect your `User` model and create, update, and delete the corresponding user inside of Userlist. To customize the `identifier`, `email`, or `properties` transmitted for a user, you can overwrite the according methods in your `User` model.

```ruby
class User < ApplicationRecord
  def userlist_properties
    { first_name: first_name, last_name: last_name }
  end

  def userlist_identifier
    "user-#{id}"
  end

  def userlist_email
    email
  end
end
```

#### Sending user data manually

To manually send user data into Userlist, use the `Userlist::Push.users.push` method.

```ruby
Userlist::Push.users.push(identifier: user.id, email: user.email, properties: { first_name: user.first_name, last_name: user.last_name })
```

It's also possible to delete a user from Userlist, using the `Userlist::Push.users.delete` method.

```ruby
Userlist::Push.users.delete(user.id)
```

### Tracking Events

To track custom events use the `Userlist::Push.events.push` method.

```ruby
Userlist::Push.events.push(name: 'project_created', user: current_user, properties: { project_name: project.name })
```

It is possible to make the `user` property optional by setting it for the entire request using an `around_action` callback in your `ApplicationController`.

```ruby
class ApplicationController < ActionController::Base
  around_action :setup_userlist_current_user

  def setup_userlist_current_user(&block)
    Userlist::Rails.with_current_user(current_user, &block)
  end
end
```

This simplifies the tracking call for the current request.

```ruby
Userlist::Push.events.push(name: 'project_created', properties: { project_name: project.name })
```

### Batch importing

You can import (and update) all your existing users and companies into Userlist by running the import rake task:

```shell
rake userlist:import
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/userlistio/userlist-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Userlist::Rails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/userlistio/userlist-rails/blob/master/CODE_OF_CONDUCT.md).
