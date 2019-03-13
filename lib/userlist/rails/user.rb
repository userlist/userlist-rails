require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module User
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

      def userlist_email
        return email if respond_to?(:email)
      end

      def userlist_company
        nil
      end

      def userlist_payload
        {
          identifier: userlist_identifier,
          email: userlist_email,
          company: userlist_company,
          properties: userlist_properties,
          signed_up_at: created_at
        }
      end

      def userlist_push
        Userlist::Push.user(userlist_payload)
      end
    end
  end
end
