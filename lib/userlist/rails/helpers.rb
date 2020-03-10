module Userlist
  module Rails
    module Helpers
      def userlist_script_tag(*args)
        config = Userlist.config
        logger = Userlist.logger

        options = args.extract_options!

        user = args.first
        user ||= current_user if respond_to?(:current_user)
        user ||= Userlist::Rails.current_user

        options[:async] = true

        if user
          identifier = user.userlist_identifier

          options[:data] ||= {}
          options[:data][:userlist] = Userlist::Token.generate(identifier)
        end

        script_tag = javascript_tag('window.userlist=window.userlist||function(){(userlist.q=userlist.q||[]).push(arguments)};')
        include_tag = javascript_include_tag(config.script_url, options)

        script_tag + include_tag
      rescue Userlist::Error => e
        logger.error(e.message)
        raw("<!-- #{e.class}: #{e.message} -->") unless ::Rails.env.production?
      end
    end
  end
end
