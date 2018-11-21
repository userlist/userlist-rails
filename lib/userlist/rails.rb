require 'userlist/rails/config'
require 'userlist/rails/railtie'

module Userlist
  module Rails
    def self.with_current_user(user)
      Thread.current[:userlist_current_user] = user
      yield
    ensure
      Thread.current[:userlist_current_user] = nil
    end

    def self.current_user
      Thread.current[:userlist_current_user]
    end

    def self.detect_model(*names)
      names.each do |name|
        begin
          return name.constantize
        rescue NameError
          false
        end
      end

      nil
    end
  end
end
