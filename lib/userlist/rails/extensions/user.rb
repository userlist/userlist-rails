module Userlist
  module Rails
    module Extensions
      module User
        module ClassMethods
          def from_payload(payload, config = Userlist.config)
            user_model = config.user_model
            user_transform = config.user_transform

            payload = user_transform.new(payload, config) if user_model && payload.is_a?(user_model)

            super
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end

        def identifier
          super if !payload.respond_to?(:destroyed?) || !payload.destroyed?
        end

        def identifiers
          super if payload.respond_to?(:destroyed?) && payload.destroyed?
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
