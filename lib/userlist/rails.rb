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

    def self.setup_callbacks(model, scope)
      return unless method = [:after_commit, :after_save].find { |m| model.respond_to?(m) }

      model.public_send(method, -> { scope.create(self) }, on: [:create, :update])
      model.public_send(method, -> { scope.delete(self) }, on: [:destroy])
    end
  end
end
