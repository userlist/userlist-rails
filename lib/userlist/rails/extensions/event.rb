module Userlist
  module Rails
    module Extensions
      module Event
        def initialize(payload)
          payload[:user] ||= Userlist::Rails.current_user

          super
        end
      end
    end
  end
end
