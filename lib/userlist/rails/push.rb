if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5.0')
  require 'active_support/core_ext/hash/transform_values'
end

module Userlist
  module Rails
    module Push
      def event(payload = {})
        payload[:user] ||= Userlist::Rails.current_user

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
        if value.respond_to?(:userlist_payload)
          value.send(:userlist_payload)
        else
          value
        end
      end
    end
  end
end
