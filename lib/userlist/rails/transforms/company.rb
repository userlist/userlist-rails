require 'userlist/rails/transform'

module Userlist
  module Rails
    module Transforms
      class Company < Userlist::Rails::Transform
        def self.attributes
          @attributes ||= [
            :identifier,
            :properties,
            :relationships,
            :name,
            :signed_up_at
          ]
        end

        def default_identifier
          "#{model.class.name}-#{model.id}".parameterize
        end

        def default_properties
          {}
        end

        def default_name
          model.try(:name)
        end

        def default_signed_up_at
          model.try(:created_at)
        end

      private

        def build_relationship(record)
          { user: record }
        end

        def relationship_from
          config.company_model
        end

        def relationship_to
          config.user_model
        end
      end
    end
  end
end
