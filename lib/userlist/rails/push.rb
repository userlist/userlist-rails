module Userlist
  module Rails
    module Push
      def event(payload = {})
        super(transform_payload(payload))
      end
      alias track event

      def user(payload = {})
        super(transform_payload(payload))
      end
      alias identify user

    private

      def transform_payload(payload)
        payload = transform_value(payload)

        return payload unless payload.is_a?(Hash)

        payload.transform_values do |value|
          result = transform_value(value)
          result = transform_payload(result) if result.is_a?(Hash)
          result
        end
      end

      def transform_value(value)
        if value.respond_to?(:userlist_attributes)
          value.send(:userlist_attributes)
        else
          value
        end
      end
    end
  end
end
