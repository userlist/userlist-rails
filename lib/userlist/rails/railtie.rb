require 'rails/railtie'

require 'userlist'
require 'userlist/config'
require 'userlist/rails/logger'
require 'userlist/rails/user'
require 'userlist/rails/company'

require 'userlist/rails/extensions/resource'
require 'userlist/rails/extensions/event'

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

      initializer 'userlist.extensions' do
        Userlist::Push::Resource.prepend(Userlist::Rails::Extensions::Resource)
        Userlist::Push::Event.prepend(Userlist::Rails::Extensions::Event)
      end

      initializer 'userlist.models' do
        config.to_prepare do
          userlist = ::Rails.application.config.userlist

          if userlist.auto_discover
            Userlist.logger.info('Automatically discovering models')

            userlist.user_model ||= Userlist::Rails.detect_model('User')
            userlist.company_model ||= Userlist::Rails.detect_model('Account', 'Company')
          end

          if user_model = userlist.user_model
            Userlist.logger.info("Preparing user model #{user_model}")
            user_model.send(:include, Userlist::Rails::User)
          end

          if company_model = userlist.company_model
            Userlist.logger.info("Preparing company model #{company_model}")
            company_model.send(:include, Userlist::Rails::Company)
          end
        end
      end
    end
  end
end
