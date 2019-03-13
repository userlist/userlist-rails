require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module Company
      extend ActiveSupport::Concern

      included do
        method = [:after_commit, :after_save].find { |m| respond_to?(m) }
        public_send(method, :userlist_push) if method
      end

      def userlist_identifier
        "#{self.class.name}-#{id}".parameterize
      end

      def userlist_properties
        {}
      end

      def userlist_payload
        {
          identifier: userlist_identifier,
          name: userlist_name,
          properties: userlist_properties
        }
      end

      def userlist_name
        return name if respond_to?(:name)
      end

      def userlist_push
        Userlist::Push.company(userlist_payload)
      end
    end
  end
end
