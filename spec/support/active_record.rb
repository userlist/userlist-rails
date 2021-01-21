ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

RSpec.configure do |config|
  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run

      raise ActiveRecord::Rollback
    end
  end
end
