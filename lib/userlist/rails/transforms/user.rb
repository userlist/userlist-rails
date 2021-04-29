require 'userlist/rails/transform'

module Userlist
  module Rails
    module Transforms
      class User < Userlist::Rails::Transform
        def self.attributes
          @attributes ||= [
            :identifier,
            :properties,
            :relationships,
            :email,
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
          model.try(:userlist_relationships) || auto_detect_relationships(config.user_model, config.company_model)
        end

        def email
          model.try(:userlist_email) || model.try(:email)
        end

        def signed_up_at
          model.try(:created_at)
        end

      private

        def build_relationship(record)
          { company: record }
        end
      end
    end
  end
end
