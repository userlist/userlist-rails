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

        def properties
          model.try(:userlist_properties) || {}
        end

        def user
          user_method = Userlist::Rails.find_reflection(config.relationship_model, config.user_model)&.name

          model.try(:userlist_user) || (user_method && model.try(user_method))
        end

        def company
          company_method = Userlist::Rails.find_reflection(config.relationship_model, config.company_model)&.name

          model.try(:userlist_company) || (company_method && model.try(company_method))
        end
      end
    end
  end
end
