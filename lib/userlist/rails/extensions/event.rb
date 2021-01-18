module Userlist
  module Rails
    module Extensions
      module Event
        module ClassMethods
          def new(payload, config = Userlist.config)
            payload[:user] = Userlist::Rails.current_user unless payload.key?(:user)
            payload[:company] = Userlist::Rails.current_company unless payload.key?(:company)

            super
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end
      end
    end
  end
end
