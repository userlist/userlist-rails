module Userlist
  module Rails
    module Extensions
      module Company
        def from_payload(payload, config = Userlist.config)
          company_model = config.company_model
          company_transform = config.company_transform

          if company_model && payload.is_a?(company_model)
            payload = company_transform.new(payload, config)
          end

          super
        end
      end
    end
  end
end
