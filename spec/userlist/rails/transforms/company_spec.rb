require 'spec_helper'

RSpec.describe Userlist::Rails::Transforms::Company do
  let(:config) { Userlist.config.merge(company_model: Company) }
  let(:company) { Company.create(name: 'Example, Inc.') }

  subject { described_class.new(company, config) }

  describe '#identifier' do
    it 'should generate a default identifier' do
      expect(subject.identifier).to eq("company-#{company.id}")
    end

    it 'should use the userlist_identifier method' do
      company.define_singleton_method(:userlist_identifier) { 'test-identifier' }
      expect(subject.identifier).to eq('test-identifier')
    end
  end

  describe '#properties' do
    it 'should generate a default properties hash' do
      expect(subject.properties).to eq({})
    end

    it 'should use the userlist_properties method' do
      company.define_singleton_method(:userlist_properties) { { testing: true } }
      expect(subject.properties).to eq({ testing: true })
    end
  end

  describe '#name' do
    it 'should use the models name column' do
      expect(subject.name).to eq(company.name)
    end

    it 'should use the userlist_name method' do
      company.define_singleton_method(:userlist_name) { 'Test, Inc.' }
      expect(subject.name).to eq('Test, Inc.')
    end
  end

  describe '#signed_up_at' do
    it 'should use the created_at attribute as signed_up_at method' do
      expect(subject.signed_up_at).to eq(company.created_at)
    end
  end

  describe '#relationships' do
    let(:config) { Userlist.config.merge(user_model: scope::User, company_model: scope::Company) }
    let(:company) { scope::Company.create(name: 'Example, Inc.') }
    let(:user) { scope::User.create(email: 'foo@example.com') }

    context 'when it is a has many through relationship' do
      let(:scope) { HasManyThrough }

      before do
        config.relationship_model = scope::Membership
        company.memberships.create!(user: user)
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(company.memberships)
      end
    end

    context 'when it is a has and belongs to many relationship' do
      let(:scope) { HasAndBelongsToMany }

      before do
        company.users << user

        puts company.users.inspect
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(company.users.map { |user| { user: user } })
      end
    end

    context 'when it is a has many relationship' do
      let(:scope) { HasManyUsers }

      before do
        company.users << user
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(company.users.map { |user| { user: user } })
      end
    end

    context 'when it is a has one relationship' do
      let(:scope) { HasOneUser }

      before do
        company.user = user
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq([{ user: company.user }])
      end
    end

    context 'when it is a belongs to relationship' do
      let(:scope) { HasManyCompanies }

      before do
        company.user = user
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq([{ user: company.user }])
      end
    end
  end
end
