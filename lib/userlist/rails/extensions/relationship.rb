module Userlist
  module Rails
    module Extensions
      module Relationship
        module ClassMethods
          def from_payload(payload, config = Userlist.config)
            relationship_model = config.relationship_model
            relationship_transform = config.relationship_transform

            payload = relationship_transform.new(payload, config) if relationship_model && payload.is_a?(relationship_model)

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
