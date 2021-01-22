# Userlist for Ruby on Rails [![Build Status](https://github.com/userlist/userlist-rails/workflows/Tests/badge.svg)](https://github.com/userlist/userlist-rails)

This gem helps with integrating [Userlist](http://userlist.com) into Ruby on Rails applications.

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

The only required configuration is the Push API key. You can get your Push API key via the [Push API settings](https://app.userlist.com/settings/push) in your Userlist account.

Configuration values can either be set via an initializer or as environment variables. The environment take precedence over configuration values from the initializer. Please refer to the [userlist](http://github.com/userlist/userlist-ruby) gem for additional configuration options.

Configuration via environment variables:

```shell
USERLIST_PUSH_KEY=VvB7pjDrv0V2hoaOCeZ5rIiUEPbEhSUN
USERLIST_PUSH_ID=6vPkJl44cm82y4aLBIzaOhuEHJd0Bm7b
```

Configuration via an initializer:

```ruby
# config/initializer/userlist.rb
Userlist.configure do |config|
  config.push_key = 'VvB7pjDrv0V2hoaOCeZ5rIiUEPbEhSUN'
  config.push_id = '6vPkJl44cm82y4aLBIzaOhuEHJd0Bm7b'
end
```

In addition to the configuration options of the [userlist](http://github.com/userlist/userlist-ruby#configuration) gem, the following options are available.

| Name            | Default value                | Description                                                                                                          |
| --------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `user_model`    | `nil`                        | The user model to use. Will be automatically set when `auto_discover` is `true`                                      |
| `company_model` | `nil`                        | The company model to use. Will be automatically set when `auto_discover` is `true`                                   |
| `relationship_model` | `nil`                        | The relationship model to use. Will be automatically infered from the user and company models                                   |
| `auto_discover` | `true`                       | The gem will try to automatically identify your `User` and `Company` models. Possible values are `true` and `false`. |
| `script_url`    | `https://js.userlist.com/v1` | The script url to load the Userlist in-app messages script from.                                                     |

### Disabling in development and test environments

As sending test and development data into data into Userlist isn't very desirable, you can disable transmissions by setting the push strategy to `:null`.

```ruby
# config/initializer/userlist.rb
Userlist.configure do |config|
  config.push_strategy = :null unless Rails.env.production?
end
```

## Usage

> ⚠️ **Important:** If you're using [Segment](https://segment.com) in combination with this gem, please make sure that both are using the same user identifier. By default, this gem will send `"user-#{id}"` (a combination of the user's primary key in the database and the `user-` prefix) as identifier. Either customize the `userlist_identifier` method on your User model, or ensure that you use the same identifier in your Segment integration.

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
Userlist::Push.users.push(user)
```

It's also possible to customize the payload sent to Userlist by passing a hash instead of the user object.

```ruby
Userlist::Push.users.push(identifier: user.id, email: user.email, properties: { first_name: user.first_name, last_name: user.last_name })
```

#### Ignoring users

For cases where you don't want to send specific user to Userlist you can add a `userlist_push?` method. Whenever this method doesn't return a falsey value, this user will not be sent to Userlist. This also applies to any events or relationships this user is involved in.

```ruby
class User < ApplicationRecord
  def userlist_push?
    !deleted? && !guest?
  end
end
```

#### Deleting users

It's also possible to delete a user from Userlist, using the `Userlist::Push.users.delete` method.

```ruby
Userlist::Push.users.delete(user)
```


### Tracking Companies

#### Sending company data automatically

By default, this gem will automatically detect your company model (like `Account`, `Company`, `Team`, `Organization`) and create, update, and delete the corresponding company inside of Userlist. To customize the `identifier`, `name`, or `properties` transmitted for a company, you can overwrite the according methods in your company model.

```ruby
class Account < ApplicationRecord
  def userlist_properties
    { projects: projects.count }
  end

  def userlist_identifier
    "account-#{id}"
  end

  def userlist_name
    name
  end
end
```


#### Sending company data manually

To manually send company data into Userlist, use the `Userlist::Push.companies.push` method.

```ruby
Userlist::Push.companies.push(user)
```

It's also possible to customize the payload sent to Userlist by passing a hash instead of the company object.

```ruby
Userlist::Push.companies.push(identifier: company.id, name: company.name, properties: { projects: company.projects.count })
```


#### Ignoring companies

For cases where you don't want to send specific company to Userlist you can add a `userlist_push?` method. Whenever this method doesn't return a falsey value, this company will not be sent to Userlist. This also applies to any events or relationships this company is involved in.

```ruby
class User < ApplicationRecord
  def userlist_push?
    !deleted? && !guest?
  end
end
```

#### Deleting users

It's also possible to delete a company from Userlist, using the `Userlist::Push.companies.delete` method.

```ruby
Userlist::Push.companies.delete(company)
```

### Tracking relationships

Userlist supports n:m relationships between users and companies. This gem will try to figure out the model your application uses to describe these relationships by looking at the associations defined in your user and company models. When sending a user to Userlist, this gem will try to automatically include the user's relationships as well. This includes information about the relationships and companies this user is associated with, but not information about other users associated with any of the companies. This works the other way around as well. When sending a company, it'll try to automatically include the company's relationships, but not any information about the associated users' other companies.

```ruby
user = User.create(email: 'foo@example.com')
user.companies.create(name: 'Example, Inc.')

Userlist::Push.users.push(user)

# Payload sent to Userlist
{
  identifier: 'user-1',
  email: 'foo@example.com',
  relationships: [
    {
      user: 'user-identifier',
      company: {
        identifier: 'company-identifier',
        name: 'Example, Inc.',
      }
    }
  ]
}
```

Similar to users and events, these relationships may define a `userlist_properties` method to provide addition properties that describe the relationship.

```ruby
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  def userlist_properties
    { role: role }
  end
end
```


#### Customizing relationship lookup

It's possible to customize the way this gem looks up relationships for users and companies by specifying a `userlist_relationships` method on the user and/or company model.  

```ruby
class User < ApplicationRecord
  def userlist_relationships
    memberships.where(role: 'owner')
  end
end
```


#### Ignoring relationships

This gem automatically ignore relationship if either the user or the company is ignored. However, in some cases it might be desirable to ignore relationships even when they connect to valid objects. A typical example for this are pending invitations. To support this use case, you can provide a `userlist_push?` method. Whenever this method doesn't return a falsey value, this relationship will not be sent to Userlist.

```ruby
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  def userlist_push?
    pending?
  end
end
```

#### Deleting relationships

It's also possible to delete a relationship from Userlist, using the `Userlist::Push.relationship.delete` method.

```ruby
Userlist::Push.relationship.delete(membership)
```

### Tracking Events

To track custom events use the `Userlist::Push.events.push` method. Events can be related to a user, a company, or both.

```ruby
Userlist::Push.events.push(name: 'project_created', user: current_user, company: current_account, properties: { project_name: project.name })
```

### Enabling in-app messages

In order to use in-app messages, please set both the `push_key` and `push_id` configuration variables. Afterwards, include the `userlist_script_tag` helper into your application's layout for signed in users.

```erb
<%= userlist_script_tag %>
```

By default, the helper will try to use the `current_user` helper to read the currently signed in user. You can change the default bebahvior by passing a different user. The passed object must respond to the `userlist_identifier` method.

```erb
<%= userlist_script_tag(user) %>
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

Bug reports and pull requests are welcome on GitHub at <https://github.com/userlist/userlist-rails>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Userlist::Rails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/userlist/userlist-rails/blob/master/CODE_OF_CONDUCT.md).

## What is Userlist?

[![Userlist](https://userlist.com/images/external/userlist-logo-github.svg)](https://userlist.com/)

[Userlist](https://userlist.com/) allows you to onboard and engage your SaaS users with targeted behavior-based campaigns using email or in-app messages.

Userlist was started in 2017 as an alternative to bulky enterprise messaging tools. We believe that running SaaS products should be more enjoyable. Learn more [about us](https://userlist.com/about-us/).
