require 'userlist/config'

require 'userlist/rails/transforms/user'
require 'userlist/rails/transforms/company'
require 'userlist/rails/transforms/relationship'

module Userlist
  module Rails
    module Config
      DEFAULT_CONFIGURATION = {
        user_model: nil,
        company_model: nil,
        relationship_model: nil,
        auto_discover: true,
        script_url: 'https://js.userlist.com/v1',
        user_transform: Userlist::Rails::Transforms::User,
        company_transform: Userlist::Rails::Transforms::Company,
        relationship_transform: Userlist::Rails::Transforms::Relationship
      }.freeze

      def default_config
        super.merge(DEFAULT_CONFIGURATION)
      end

      def auto_discover
        [true, 'true'].include?(super)
      end

      def user_model
        (model = super) && model.is_a?(Class) ? model : model&.to_s&.constantize
      end

      def company_model
        (model = super) && model.is_a?(Class) ? model : model&.to_s&.constantize
      end

      Userlist::Config.send(:prepend, self)
    end
  end
end
