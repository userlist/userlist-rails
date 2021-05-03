require 'userlist/rails/transform'
require 'userlist/rails/transforms/has_relationships'

module Userlist
  module Rails
    module Transforms
      class User < Userlist::Rails::Transform
        include HasRelationships

        def self.attributes
          @attributes ||= [
            :identifier,
            :properties,
            :relationships,
            :email,
            :signed_up_at
          ]
        end

        def default_identifier
          "#{model.class.name}-#{model.id}".parameterize
        end

        def default_properties
          {}
        end

        def default_email
          model.try(:email)
        end

        def default_signed_up_at
          model.try(:created_at)
        end

      private

        def build_relationship(record)
          {
            user: model,
            company: record
          }
        end

        def relationship_from
          config.user_model
        end

        def relationship_to
          config.company_model
        end
      end
    end
  end
end
