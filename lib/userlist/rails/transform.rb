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
        public_send(name) if key?(name)
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

    private

      attr_reader :model, :config
    end
  end
end
