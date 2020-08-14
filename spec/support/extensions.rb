begin
  initializer = Userlist::Rails::Railtie.initializers.find { |i| i.name == 'userlist.extensions' }
  initializer.run
end
