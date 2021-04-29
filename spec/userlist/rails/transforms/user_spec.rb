require 'spec_helper'

RSpec.describe Userlist::Rails::Transforms::User do
  let(:config) { Userlist.config.merge(user_model: User) }
  let(:user) { User.create(email: 'foo@example.com') }

  subject { described_class.new(user, config) }

  describe '#default_identifier' do
    it 'should generate a default identifier' do
      expect(subject.default_identifier).to eq("user-#{user.id}")
    end
  end

  describe '#default_properties' do
    it 'should generate a default properties hash' do
      expect(subject.default_properties).to eq({})
    end
  end

  describe '#default_email' do
    it 'should use the users email column' do
      expect(subject.default_email).to eq(user.email)
    end
  end

  describe '#default_signed_up_at' do
    it 'should use the created_at attribute as signed_up_at method' do
      expect(subject.default_signed_up_at).to eq(user.created_at)
    end
  end

  describe '#default_relationships' do
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
        expect(subject.default_relationships).to eq(user.memberships)
      end
    end

    context 'when it is a has and belongs to many relationship' do
      let(:scope) { HasAndBelongsToMany }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq(user.companies.map { |company| { company: company } })
      end
    end

    context 'when it is a has many relationship' do
      let(:scope) { HasManyCompanies }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq(user.companies.map { |company| { company: company } })
      end
    end

    context 'when it is a has one relationship' do
      let(:scope) { HasOneCompany }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq([{ company: user.company }])
      end
    end

    context 'when it is a belongs to relationship' do
      let(:scope) { HasManyUsers }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq([{ company: user.company }])
      end
    end
  end
end
