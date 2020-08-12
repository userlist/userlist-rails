module Userlist
  module Rails
    module Extensions
      module User
        def from_payload(payload, config = Userlist.config)
          if config.user_model && payload.is_a?(config.user_model)
            payload = {
              identifier: payload.try(:userlist_identifier) || "#{payload.class.name}-#{payload.id}".parameterize,
              properties: payload.try(:userlist_properties) || {},
              email: payload.try(:userlist_email) || payload.try(:email),
              signed_up_at: payload.try(:created_at)
            }
          end

          super
        end
      end
    end
  end
end
