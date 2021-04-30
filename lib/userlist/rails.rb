require 'userlist/rails/config'
require 'userlist/rails/railtie'

module Userlist
  module Rails
    DEPRECATED_MODEL_METHODS = [
      :userlist_push,
      :userlist_delete,
      :userlist_payload,
      :userlist_company,
      :userlist_user
    ].freeze

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
          model = name.constantize

          return model if model.is_a?(Class)
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

    def self.find_association_between(from, to)
      return unless association = Userlist::Rails.find_reflection(from, to)

      association.through_reflection || association
    end

    def self.setup_callbacks(model, scope)
      return if model.instance_variable_get(:@userlist_callbacks_registered)

      setup_callback(:create,  model, scope, :push)
      setup_callback(:update,  model, scope, :push)
      setup_callback(:destroy, model, scope, :delete)

      model.instance_variable_set(:@userlist_callbacks_registered, true)
    end

    def self.setup_callback(type, model, scope, method)
      return unless callback_method = [:after_commit, :"after_#{type}"].find { |m| model.respond_to?(m) }

      callback = lambda do
        begin
          relation = Userlist::Push.public_send(scope)
          relation.public_send(method, self)
        rescue Userlist::Error => e
          Userlist.logger.error "Failed to #{method} #{method.to_s.singularize}: #{e.message}"
        end
      end

      model.public_send(callback_method, callback, on: type)
    end

    def self.setup_extensions
      Userlist::Push::User.include(Userlist::Rails::Extensions::User)
      Userlist::Push::Company.include(Userlist::Rails::Extensions::Company)
      Userlist::Push::Relationship.include(Userlist::Rails::Extensions::Relationship)
      Userlist::Push::Event.include(Userlist::Rails::Extensions::Event)
    end

    def self.check_deprecations(type)
      deprecated_methods = (type.instance_methods + type.private_instance_methods) & DEPRECATED_MODEL_METHODS

      if deprecated_methods.any?
        raise <<~MESSAGE
          Deprecation warning for userlist-rails

          Customizing the way userlist-rails works has changed.

          Using the #{deprecated_methods.to_sentence} method(s) on your #{type.name} model is not supported anymore.

          For details on how to customize the gem's behavior, please see https://github.com/userlist/userlist-rails or reach out to support@userlist.com
        MESSAGE
      end

      deprecated_methods = type.private_instance_methods.grep(/userlist_/)

      if deprecated_methods.any?
        raise <<~MESSAGE
          Deprecation warning for userlist-rails

          Customizing the way userlist-rails works has changed.

          Using private methods (like #{deprecated_methods.to_sentence}) on your #{type.name} model is not supported anymore. Please use public methods instead.

          For details on how to customize the gem's behavior, please see https://github.com/userlist/userlist-rails or reach out to support@userlist.com
        MESSAGE
      end

      true
    end
  end
end
