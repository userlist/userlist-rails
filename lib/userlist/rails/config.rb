require 'userlist/config'

module Userlist
  module Rails
    module Config
      DEFAULT_CONFIGURATION = {
        user_model: nil,
        company_model: nil,
        auto_discover: true
      }.freeze

      def default_config
        super.merge(DEFAULT_CONFIGURATION)
      end

      def auto_discover
        auto_discover = super
        auto_discover == true || auto_discover == 'true'
      end

      def user_model
        model = super
        model && model.to_s.constantize
      end

      def company_model
        model = super
        model && model.to_s.constantize
      end

      Userlist::Config.send(:prepend, self)
    end
  end
end
