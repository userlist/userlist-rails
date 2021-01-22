module Userlist
  module Rails
    module Extensions
      module Company
        module ClassMethods
          def from_payload(payload, config = Userlist.config)
            company_model = config.company_model
            company_transform = config.company_transform

            payload = company_transform.new(payload, config) if company_model && payload.is_a?(company_model)

            super
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end

        def push?
          super && (!payload.respond_to?(:push?) || payload.push?)
        end

        def delete?
          super && (!payload.respond_to?(:delete?) || payload.delete?)
        end
      end
    end
  end
end
