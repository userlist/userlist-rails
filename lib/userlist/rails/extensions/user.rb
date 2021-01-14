module Userlist
  module Rails
    module Extensions
      module User
        def from_payload(payload, config = Userlist.config)
          user_model = config.user_model
          user_transform = config.user_transform

          if user_model && payload.is_a?(user_model)
            payload = user_transform.new(payload, config)
          end

          super
        end
      end
    end
  end
end
