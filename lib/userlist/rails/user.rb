require 'active_support/concern'
require 'userlist/push'

module Userlist
  module Rails
    module User
      extend ActiveSupport::Concern

      included do
        push = Userlist::Push.new

        block = lambda do
          push.user(
            identifier: userlist_identifier,
            email: userlist_email,
            properties: userlist_properties
          )
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
    end
  end
end
