# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Userlist
  module Rails
    module Extensions
      module Relationship
        def from_payload(payload, config = Userlist.config, options = {})
          relationship_model = config.relationship_model
          user_model = config.user_model
          company_model = config.company_model

          if relationship_model && payload.is_a?(relationship_model)
            user_method = Userlist::Rails.find_reflection(relationship_model, user_model)&.name
            company_method = Userlist::Rails.find_reflection(relationship_model, company_model)&.name

            payload = {
              user: payload.try(:userlist_user) || (user_method && payload.try(user_method)),
              company: payload.try(:userlist_company) || (company_method && payload.try(company_method)),
              properties: payload.try(:userlist_properties) || {}
            }.delete_if { |_, value| value.nil? }
          end

          super
        end
      end
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
