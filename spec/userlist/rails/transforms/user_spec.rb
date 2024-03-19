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
    let(:config) { Userlist.config.merge(user_model: user_model, company_model: company_model) }
    let(:user) { user_model.create(email: 'foo@example.com') }
    let(:company) { company_model.create(name: 'Example, Inc.') }

    context 'when there are no relationships' do
      let(:user_model) { User }
      let(:company_model) { Company }

      it 'should return nothing' do
        expect(subject.default_relationships).to_not be
      end
    end

    context 'when it is a has many through relationship' do
      let(:user_model) { HasManyThrough::User }
      let(:company_model) { HasManyThrough::Company }
      let(:relationship_model) { HasManyThrough::Membership }

      before do
        config.relationship_model = relationship_model
        user.memberships.create!(company: company)
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq(user.memberships)
      end

      context 'when there explicitly is no relationship model' do
        let(:relationship_model) { nil }

        it 'should return nothing' do
          expect(subject.default_relationships).to_not be
        end
      end
    end

    context 'when it is a has and belongs to many relationship' do
      let(:user_model) { HasAndBelongsToMany::User }
      let(:company_model) { HasAndBelongsToMany::Company }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq(user.companies.map { |company| { user: user, company: company } })
      end
    end

    context 'when it is a has many relationship' do
      let(:user_model) { HasManyCompanies::User }
      let(:company_model) { HasManyCompanies::Company }

      before do
        user.companies << company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq(user.companies.map { |company| { user: user, company: company } })
      end
    end

    context 'when it is a has one relationship' do
      let(:user_model) { HasOneCompany::User }
      let(:company_model) { HasOneCompany::Company }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq([{ user: user, company: user.company }])
      end
    end

    context 'when it is a belongs to relationship' do
      let(:user_model) { HasManyUsers::User }
      let(:company_model) { HasManyUsers::Company }

      before do
        user.company = company
      end

      it 'should return the relationships' do
        expect(subject.default_relationships).to eq([{ user: user, company: user.company }])
      end
    end
  end
end
