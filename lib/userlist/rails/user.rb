require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module User
      extend ActiveSupport::Concern

      included do

        block = lambda do
          Userlist::Push.user(userlist_attributes)
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

      def userlist_email
        return email if respond_to?(:email)
      end

      def userlist_company
        nil
      end

      def userlist_attributes
        {
          identifier: userlist_identifier,
          email: userlist_email,
          company: userlist_company.try(:userlist_attributes),
          properties: userlist_properties
        }
      end
    end
  end
end
