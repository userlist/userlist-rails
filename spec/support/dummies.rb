ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :email
    t.references :company
    t.timestamps
  end

  create_table :companies, force: true do |t|
    t.string :name
    t.references :user
    t.timestamps
  end

  create_table :memberships, force: true do |t|
    t.string :role
    t.references :user
    t.references :company
    t.timestamps
  end

  create_table :companies_users, force: true do |t|
    t.references :user
    t.references :company
    t.timestamps
  end
end

class User < ActiveRecord::Base
end

class Company < ActiveRecord::Base
end

module HasManyThrough
  class User < ActiveRecord::Base
    has_many :memberships, class_name: 'HasManyThrough::Membership'
    has_many :companies, through: :memberships, class_name: 'HasManyThrough::Company'
  end

  class Company < ActiveRecord::Base
    has_many :memberships, class_name: 'HasManyThrough::Membership'
    has_many :users, through: :memberships, class_name: 'HasManyThrough::User'
  end

  class Membership < ActiveRecord::Base
    belongs_to :user, class_name: 'HasManyThrough::User'
    belongs_to :company, class_name: 'HasManyThrough::Company'
  end
end

module HasAndBelongsToMany
  class User < ActiveRecord::Base
    has_and_belongs_to_many :companies, class_name: 'HasAndBelongsToMany::Company'
  end

  class Company < ActiveRecord::Base
    has_and_belongs_to_many :users, class_name: 'HasAndBelongsToMany::User'
  end
end

module HasManyCompanies
  class User < ActiveRecord::Base
    has_many :companies, class_name: 'HasManyCompanies::Company'
  end

  class Company < ActiveRecord::Base
    belongs_to :user, class_name: 'HasManyCompanies::User'
  end
end

module HasOneCompany
  class User < ActiveRecord::Base
    has_one :company, class_name: 'HasOneCompany::Company'
  end

  class Company < ActiveRecord::Base
    belongs_to :user, class_name: 'HasOneCompany::User'
  end
end

module HasManyUsers
  class User < ActiveRecord::Base
    belongs_to :company, class_name: 'HasManyUsers::Company'
  end

  class Company < ActiveRecord::Base
    has_many :users, class_name: 'HasManyUsers::User'
  end
end

module HasOneUser
  class User < ActiveRecord::Base
    belongs_to :company, class_name: 'HasOneUser::Company'
  end

  class Company < ActiveRecord::Base
    has_one :user, class_name: 'HasOneUser::User'
  end
end

module MultipleRelationships
  class User < ActiveRecord::Base
    has_many :memberships, class_name: 'MultipleRelationships::Membership'
    has_many :companies, through: :memberships, class_name: 'MultipleRelationships::Company'

    has_many :direct_companies, class_name: 'MultipleRelationships::Company'
    has_one :company, class_name: 'MultipleRelationships::Company'
  end

  class Company < ActiveRecord::Base
    has_many :direct_users, class_name: 'MultipleRelationships::User'

    has_many :memberships, class_name: 'MultipleRelationships::Membership'
    has_many :users, through: :memberships, class_name: 'MultipleRelationships::User'
  end

  class Membership < ActiveRecord::Base
    belongs_to :user, class_name: 'MultipleRelationships::User'
    belongs_to :company, class_name: 'MultipleRelationships::Company'
  end
end
