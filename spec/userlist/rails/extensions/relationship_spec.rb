require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Relationship do
  describe '.from_payload' do
    let(:config) { Userlist.config.merge(user_model: user_model, company_model: company_model, relationship_model: relationship_model) }

    let(:user) { user_model.create(email: 'foo@example.com') }
    let(:company) { company_model.create(name: 'Example, Inc.') }
    let(:relationship) { relationship_model.create(user: user, company: company) }

    let(:user_model) { HasManyThrough::User }
    let(:company_model) { HasManyThrough::Company }
    let(:relationship_model) { HasManyThrough::Membership }

    let(:resource) { Userlist::Push::Relationship.from_payload(relationship, config) }

    context 'for properties' do
      it 'should use the model\'s userlist_properties' do
        relationship.define_singleton_method(:userlist_properties) { { foo: :bar } }
        expect(resource.properties).to eq({ foo: :bar })
      end

      it 'should use an empty hash as fallback' do
        expect(resource.properties).to eq({})
      end
    end

    describe '#push?' do
      it 'should return true by default' do
        expect(resource.push?).to eq(true)
      end

      it 'should return the value of the userlist_push? method' do
        relationship.define_singleton_method(:userlist_push?) { false }
        expect(resource.push?).to eq(false)
      end
    end

    describe '#delete?' do
      it 'should return false by default' do
        expect(resource.delete?).to eq(true)
      end

      it 'should return the value of the userlist_delete? method' do
        relationship.define_singleton_method(:userlist_delete?) { false }
        expect(resource.delete?).to eq(false)
      end
    end
  end
end
