ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :email
    t.timestamps
  end

  create_table :companies, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :memberships, force: true do |t|
    t.references :user
    t.references :company
    t.string :role
    t.timestamps
  end
end

class User < ActiveRecord::Base
  has_many :memberships
  has_many :companies, through: :memberships
end

class Company < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
end

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
end
