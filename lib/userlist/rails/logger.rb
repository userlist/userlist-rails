module Userlist
  module Rails
    class Logger
      include ::Logger::Severity

      def initialize(logger, config = {})
        @logger = logger
        @config = Userlist.config.merge(config)
      end

      def add(severity, message = nil, progname = nil)
        return true if (severity || UNKNOWN) < level
        logger.add(severity, "[userlist-rails] #{message}", progname)
      end

      constants.each do |severity|
        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def #{severity.downcase}(*args)          # def debug(*args)
            add(#{severity}, *args)                #   add(DEBUG, *args)
          end                                      # end
        RUBY
      end

    private

      attr_reader :logger, :config

      def level
        @level ||= self.class.const_get(config.log_level.to_s.upcase)
      end
    end
  end
end
