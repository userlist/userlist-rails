require 'userlist/rails/transform'

module Userlist
  module Rails
    module Transforms
      class Relationship < Userlist::Rails::Transform
        def self.attributes
          @attributes ||= [
            :user,
            :company,
            :properties
          ]
        end

        def default_properties
          {}
        end

        def default_user
          user_method = Userlist::Rails.find_reflection(config.relationship_model, config.user_model)&.name

          user_method && model.try(user_method)
        end

        def default_company
          company_method = Userlist::Rails.find_reflection(config.relationship_model, config.company_model)&.name

          company_method && model.try(company_method)
        end
      end
    end
  end
end
