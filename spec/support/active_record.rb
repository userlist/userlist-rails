ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

RSpec.configure do |config|
  config.around(:each) do |example|
    connection = ActiveRecord::Base.connection
    connection.begin_transaction(joinable: false)
    example.run
    connection.rollback_transaction
  end
end
