Userlist::Rails::Railtie
  .initializers
  .find { |i| i.name == 'userlist.extensions' }
  .run
