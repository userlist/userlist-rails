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

    def self.with_current_company(company)
      Thread.current[:userlist_current_company] = company
      yield
    ensure
      Thread.current[:userlist_current_company] = nil
    end

    def self.current_company
      Thread.current[:userlist_current_company]
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

    def self.detect_relationship(from, to)
      return unless reflection = find_reflection(from, to)

      reflection.through_reflection.klass if reflection.through_reflection?
    end

    def self.find_reflection(from, to)
      return unless from && to

      from.reflect_on_all_associations.find { |r| r.class_name == to.to_s }
    end

    def self.setup_callbacks(model, scope)
      return if model.instance_variable_get(:@userlist_callbacks_registered)

      setup_callback(:create,  model, -> { Userlist::Push.public_send(scope).create(self) })
      setup_callback(:update,  model, -> { Userlist::Push.public_send(scope).create(self) })
      setup_callback(:destroy, model, -> { Userlist::Push.public_send(scope).delete(self) })

      model.instance_variable_set(:@userlist_callbacks_registered, true)
    end

    def self.setup_callback(type, model, callback)
      return unless method = [:after_commit, :"after_#{type}"].find { |m| model.respond_to?(m) }

      model.public_send(method, callback, on: type)
    end
  end
end
