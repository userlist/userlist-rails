module Userlist
  module Rails
    class Transform
      def self.attributes
        @attributes = []
      end

      def initialize(model, config = Userlist.config)
        @model = model
        @config = config
      end

      def [](name)
        model.try("userlist_#{name}") || public_send("default_#{name}") if key?(name)
      end

      def key?(name)
        keys.include?(name.to_sym)
      end

      def keys
        self.class.attributes
      end

      def hash
        model.hash
      end

      def push?
        (!model.respond_to?(:userlist_push?) || model.userlist_push?)
      end

      def delete?
        (!model.respond_to?(:userlist_delete?) || model.userlist_delete?)
      end

      def default_relationships
        association = Userlist::Rails.find_association_between(relationship_from, relationship_to)

        records = Array.wrap(model.try(association&.name))

        if association.klass == config.relationship_model
          records
        else
          records.map { |record| build_relationship(record) }
        end
      end

    private

      attr_reader :model, :config

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
