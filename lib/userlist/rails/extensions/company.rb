# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Userlist
  module Rails
    module Extensions
      module Company
        def from_payload(payload, config = Userlist.config, options = {})
          company_model = config.company_model

          if company_model && payload.is_a?(company_model)
            relationships_method = Userlist::Rails.find_reflection(company_model, config.relationship_model)&.name

            payload = {
              identifier: payload.try(:userlist_identifier) || "#{payload.class.name}-#{payload.id}".parameterize,
              properties: payload.try(:userlist_properties) || {},
              relationships: payload.try(:userlist_relationships) || (relationships_method && payload.try(relationships_method)),
              name: payload.try(:userlist_name) || payload.try(:name),
              signed_up_at: payload.try(:created_at)
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
