require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module Company
      extend ActiveSupport::Concern

      included do
        block = lambda do
          Userlist::Push.company(userlist_payload)
        end

        if respond_to?(:after_commit)
          after_commit(&block)
        elsif respond_to?(:after_save)
          after_save(&block)
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
    end
  end
end
