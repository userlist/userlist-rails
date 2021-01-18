module Userlist
  module Rails
    module Extensions
      module Company
        module ClassMethods
          def from_payload(payload, config = Userlist.config)
            company_model = config.company_model
            company_transform = config.company_transform

            if company_model && payload.is_a?(company_model)
              payload = company_transform.new(payload, config)
            end

            super
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end

        def create?
          !payload.respond_to?(:create?) || payload.create?
        end

        def delete?
          !payload.respond_to?(:delete?) || payload.delete?
        end
      end
    end
  end
end
