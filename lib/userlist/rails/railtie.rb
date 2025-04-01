require 'rails/railtie'

require 'userlist'
require 'userlist/config'
require 'userlist/rails/logger'

require 'userlist/rails/extensions/user'
require 'userlist/rails/extensions/company'
require 'userlist/rails/extensions/relationship'
require 'userlist/rails/extensions/event'

require 'userlist/rails/helpers'

module Userlist
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load 'userlist/rails/tasks/userlist.rake'
      end

      initializer 'userlist.config' do
        config.userlist = Userlist.config
      end

      initializer 'userlist.strategy' do
        config.after_initialize do
          strategy = config.userlist.push_strategy
          Userlist::Push::Strategies.require_strategy(strategy)
        end
      end

      initializer 'userlist.logger' do
        config.after_initialize do
          Userlist.logger = Userlist::Rails::Logger.new(::Rails.logger, config.userlist)
        end
      end

      initializer 'userlist.helpers' do
        ActiveSupport.on_load(:action_view) do
          include Userlist::Rails::Helpers
        end
      end

      initializer 'userlist.extensions' do
        Userlist::Rails.setup_extensions
      end

      initializer 'userlist.models' do
        config.to_prepare do
          userlist = ::Rails.application.config.userlist

          if userlist.auto_discover
            Userlist.logger.info('Automatically discovering models')

            userlist.user_model = Userlist::Rails.detect_model('User')
            userlist.company_model = Userlist::Rails.detect_model('Account', 'Company', 'Team', 'Organization')
            userlist.relationship_model = Userlist::Rails.detect_relationship(userlist.user_model, userlist.company_model)
          end

          if user_model = userlist.user_model
            Userlist.logger.info("Preparing user model #{user_model}")
            Userlist::Rails.check_deprecations(user_model)
            Userlist::Rails.setup_callbacks(user_model, :users)
          end

          if company_model = userlist.company_model
            Userlist.logger.info("Preparing company model #{company_model}")
            Userlist::Rails.check_deprecations(company_model)
            Userlist::Rails.setup_callbacks(company_model, :companies)
          end

          if relationship_model = userlist.relationship_model
            Userlist.logger.info("Preparing relationship model #{relationship_model}")
            Userlist::Rails.setup_callbacks(relationship_model, :relationships)
          end
        end
      end

      initializer 'userlist.delivery_method', before: 'action_mailer.set_configs' do
        ActiveSupport.on_load(:action_mailer) do
          ActionMailer::Base.add_delivery_method(:userlist, Userlist::DeliveryMethod) if defined?(Userlist::DeliveryMethod)
        end
      end
    end
  end
end
