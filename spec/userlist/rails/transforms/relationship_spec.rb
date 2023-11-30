require 'spec_helper'

RSpec.describe Userlist::Rails::Transforms::Relationship do
  let(:config) { Userlist.config.merge(user_model: user_model, company_model: company_model, relationship_model: relationship_model) }

  let(:user) { user_model.create(email: 'foo@example.com') }
  let(:company) { company_model.create(name: 'Example, Inc.') }
  let(:relationship) { relationship_model.create(user: user, company: company) }

  let(:user_model) { HasManyThrough::User }
  let(:company_model) { HasManyThrough::Company }
  let(:relationship_model) { HasManyThrough::Membership }

  subject { described_class.new(relationship, config) }

  describe '#default_properties' do
    it 'should generate a default properties hash' do
      expect(subject.default_properties).to eq({})
    end
  end

  describe '#default_user' do
    it 'should return the user' do
      expect(subject.default_user).to eq(user)
    end
  end

  describe '#default_company' do
    it 'should return the company' do
      expect(subject.default_company).to eq(company)
    end
  end
end
