require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::User do
  let(:resource_type) do
    type = Class.new(Userlist::Push::User)
    type.extend(described_class)
    type
  end

  describe '.from_payload' do
    let(:config) { Userlist.config.merge(user_model: User) }
    let(:user) { User.create(email: 'foo@example.com') }
    let(:resource) { resource_type.from_payload(user, config) }

    context 'for identifier' do
      it 'should use the model\'s userlist_identifier' do
        user.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
        expect(resource.identifier).to eq('custom_identifier')
      end

      it 'should use the model\'s name and id as fallback' do
        expect(resource.identifier).to eq('user-1')
      end
    end

    context 'for email' do
      it 'should use the model\'s userlist_email' do
        user.define_singleton_method(:userlist_email) { 'custom@example.com' }
        expect(resource.email).to eq('custom@example.com')
      end

      it 'should use the model\'s email as fallback' do
        expect(resource.email).to eq('foo@example.com')
      end
    end

    context 'for properties' do
      it 'should use the model\'s userlist_properties' do
        user.define_singleton_method(:userlist_properties) { { foo: :bar } }
        expect(resource.properties).to eq({ foo: :bar })
      end

      it 'should use an empty hash as fallback' do
        expect(resource.properties).to eq({})
      end
    end

    context 'for signed_up_at' do
      it 'should use the model\'s created_at' do
        expect(resource.signed_up_at).to eq(user.created_at)
      end
    end
  end
end
