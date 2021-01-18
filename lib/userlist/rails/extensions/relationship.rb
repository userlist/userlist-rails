module Userlist
  module Rails
    module Extensions
      module Relationship
        module ClassMethods
          def from_payload(payload, config = Userlist.config)
            relationship_model = config.relationship_model
            relationship_transform = config.relationship_transform

            if relationship_model && payload.is_a?(relationship_model)
              payload = relationship_transform.new(payload, config)
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
