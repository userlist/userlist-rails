require 'rails/railtie'

require 'userlist'
require 'userlist/config'
require 'userlist/rails/logger'
require 'userlist/rails/user'
require 'userlist/rails/company'

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

      initializer 'userlist.models' do
        config.after_initialize do
          if config.userlist.auto_discover
            config.userlist.user_model ||= detect_model('User')
            config.userlist.company_model ||= detect_model('Account', 'Company')
          end
        end

        config.to_prepare do
          userlist = ::Rails.application.config.userlist

          if user_model = userlist.user_model
            user_model.send(:include, Userlist::Rails::User)
          end

          if company_model = userlist.company_model
            company_model.send(:include, Userlist::Rails::Company)
          end
        end
      end

      def detect_model(*names)
        names.each do |name|
          begin
            return name.constantize
          rescue NameError
            false
          end
        end

        nil
      end
    end
  end
end
