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
        load 'tasks/userlist.rake'
      end

      initializer 'userlist.config' do
        config.userlist = Userlist.config
      end

      initializer 'userlist.logger' do
        config.after_initialize do
          Userlist.logger = Userlist::Rails::Logger.new(::Rails.logger, config.userlist)
        end
      end

      initializer 'userlist.helpers' do
        ActiveSupport.on_load :action_view do
          include Userlist::Rails::Helpers
        end
      end

      initializer 'userlist.extensions' do
        Userlist::Push::User.include(Userlist::Rails::Extensions::User)
        Userlist::Push::Company.include(Userlist::Rails::Extensions::Company)
        Userlist::Push::Relationship.include(Userlist::Rails::Extensions::Relationship)
        Userlist::Push::Event.include(Userlist::Rails::Extensions::Event)
      end

      initializer 'userlist.models' do
        config.to_prepare do
          userlist = ::Rails.application.config.userlist

          if userlist.auto_discover
            Userlist.logger.info('Automatically discovering models')

            userlist.user_model = Userlist::Rails.detect_model('User')
            userlist.company_model = Userlist::Rails.detect_model('Account', 'Company')
            userlist.relationship_model = Userlist::Rails.detect_relationship(userlist.user_model, userlist.company_model)
          end

          if user_model = userlist.user_model
            Userlist.logger.info("Preparing user model #{user_model}")
            Userlist::Rails.setup_callbacks(user_model, :users)
          end

          if company_model = userlist.company_model
            Userlist.logger.info("Preparing company model #{company_model}")
            Userlist::Rails.setup_callbacks(company_model, :companies)
          end

          if relationship_model = userlist.relationship_model
            Userlist.logger.info("Preparing relationship model #{relationship_model}")
            Userlist::Rails.setup_callbacks(relationship_model, :relationships)
          end
        end
      end
    end
  end
end
