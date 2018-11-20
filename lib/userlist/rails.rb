require 'userlist/rails/config'
require 'userlist/rails/railtie'

module Userlist
  module Rails
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
