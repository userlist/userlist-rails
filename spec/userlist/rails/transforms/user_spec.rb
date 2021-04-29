require 'spec_helper'

RSpec.describe Userlist::Rails::Transforms::User do
  let(:config) { Userlist.config.merge(user_model: User) }
  let(:user) { User.create(email: 'foo@example.com') }

  subject { described_class.new(user, config) }

  describe '#identifier' do
    it 'should generate a default identifier' do
      expect(subject.identifier).to eq("user-#{user.id}")
    end

    it 'should use the userlist_identifier method' do
      user.define_singleton_method(:userlist_identifier) { 'test-identifier' }
      expect(subject.identifier).to eq('test-identifier')
    end
  end

  describe '#properties' do
    it 'should generate a default properties hash' do
      expect(subject.properties).to eq({})
    end

    it 'should use the userlist_properties method' do
      user.define_singleton_method(:userlist_properties) { { testing: true } }
      expect(subject.properties).to eq({ testing: true })
    end
  end

  describe '#email' do
    it 'should use the users email column' do
      expect(subject.email).to eq(user.email)
    end

    it 'should use the userlist_email method' do
      user.define_singleton_method(:userlist_email) { 'test@example.org' }
      expect(subject.email).to eq('test@example.org')
    end
  end

  describe '#signed_up_at' do
    it 'should use the created_at attribute as signed_up_at method' do
      expect(subject.signed_up_at).to eq(user.created_at)
    end
  end

  describe '#relationships' do
    let(:config) { Userlist.config.merge(user_model: scope::User, company_model: scope::Company) }
    let(:user) { scope::User.create(email: 'foo@example.com') }
    let(:company) { scope::Company.create(name: 'Example, Inc.') }

    context 'when it is a has many through relationship' do
      let(:scope) { HasManyThrough }

      before do
        config.relationship_model = scope::Membership
        user.memberships.create!(company: company)
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(user.memberships)
      end
    end

    context 'when it is a has and belongs to many relationship' do
      let(:scope) { HasAndBelongsToMany }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(user.companies.map { |company| { company: company } })
      end
    end

    context 'when it is a has many relationship' do
      let(:scope) { HasManyCompanies }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq(user.companies.map { |company| { company: company } })
      end
    end

    context 'when it is a has one relationship' do
      let(:scope) { HasOneCompany }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq([{ company: user.company }])
      end
    end

    context 'when it is a belongs to relationship' do
      let(:scope) { HasManyUsers }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.relationships).to eq([{ company: user.company }])
      end
    end
  end
end
