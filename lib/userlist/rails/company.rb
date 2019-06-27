require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module Company
      extend ActiveSupport::Concern

      included do
        if method = [:after_commit, :after_save].find { |m| respond_to?(m) }
          public_send(method, :userlist_push, on: [:create, :update])
          public_send(method, :userlist_delete, on: [:destroy])
        end
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
        Userlist::Push.companies.push(userlist_payload)
      end

      def userlist_delete
        Userlist::Push.companies.delete(userlist_identifier)
      end
    end
  end
end
