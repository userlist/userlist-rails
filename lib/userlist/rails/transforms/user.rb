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

        def default_identifier
          "#{model.class.name}-#{model.id}".parameterize
        end

        def default_properties
          {}
        end

        def default_relationships
          auto_detect_relationships(config.user_model, config.company_model)
        end

        def default_email
          model.try(:email)
        end

        def default_signed_up_at
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
