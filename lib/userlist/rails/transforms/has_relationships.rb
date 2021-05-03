require 'userlist/rails/transform'

module Userlist
  module Rails
    module Transforms
      module HasRelationships
        def default_relationships
          return unless association = Userlist::Rails.find_association_between(relationship_from, relationship_to)

          records = model.try(association.name)

          if association.klass == config.relationship_model
            records
          elsif association.klass == relationship_to
            Array.wrap(records).map { |record| build_relationship(record) }
          end
        end

      private

        def build_relationship(_record)
          raise NotImplementedError
        end

        def relationship_to
          raise NotImplementedError
        end

        def relationship_from
          raise NotImplementedError
        end
      end
    end
  end
end
