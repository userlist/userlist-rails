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
          model.try(:userlist_relationships) || auto_detect_relationships(config.company_model, config.user_model)
        end

        def name
          model.try(:userlist_name) || model.try(:name)
        end

        def signed_up_at
          model.try(:created_at)
        end

      private

        def build_relationship(record)
          { user: record }
        end
      end
    end
  end
end
