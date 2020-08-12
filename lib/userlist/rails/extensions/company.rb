module Userlist
  module Rails
    module Extensions
      module Company
        def from_payload(payload, config = Userlist.config)
          if config.company_model && payload.is_a?(config.company_model)
            payload = {
              identifier: payload.try(:userlist_identifier) || "#{payload.class.name}-#{payload.id}".parameterize,
              properties: payload.try(:userlist_properties) || {},
              name: payload.try(:userlist_name) || payload.try(:name),
              signed_up_at: payload.try(:created_at)
            }
          end

          super
        end
      end
    end
  end
end
