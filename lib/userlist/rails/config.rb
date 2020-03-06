require 'userlist/config'

module Userlist
  module Rails
    module Config
      DEFAULT_CONFIGURATION = {
        user_model: nil,
        company_model: nil,
        auto_discover: true,
        script_url: 'https://js.userlist.com/v1'
      }.freeze

      def default_config
        super.merge(DEFAULT_CONFIGURATION)
      end

      def auto_discover
        [true, 'true'].include?(super)
      end

      def user_model
        super&.to_s&.constantize
      end

      def company_model
        super&.to_s&.constantize
      end

      Userlist::Config.send(:prepend, self)
    end
  end
end
