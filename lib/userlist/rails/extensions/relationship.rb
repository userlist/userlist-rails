module Userlist
  module Rails
    module Extensions
      module Relationship
        def from_payload(payload, config = Userlist.config)
          relationship_model = config.relationship_model
          relationship_transform = config.relationship_transform

          if relationship_model && payload.is_a?(relationship_model)
            payload = relationship_transform.new(payload, config)
          end

          super
        end
      end
    end
  end
end
