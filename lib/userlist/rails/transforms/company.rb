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

        def identifier
          model.try(:userlist_identifier) || "#{model.class.name}-#{model.id}".parameterize
        end

        def properties
          model.try(:userlist_properties) || {}
        end

        def relationships
          relationships_method = Userlist::Rails.find_reflection(config.company_model, config.relationship_model)&.name

          model.try(:userlist_relationships) || (relationships_method && model.try(relationships_method))
        end

        def name
          model.try(:userlist_name) || model.try(:name)
        end

        def signed_up_at
          model.try(:created_at)
        end
      end
    end
  end
end
