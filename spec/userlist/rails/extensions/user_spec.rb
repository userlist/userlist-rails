require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::User do
  describe '.from_payload' do
    let(:config) { Userlist.config.merge(user_model: User) }
    let(:user) { User.create(email: 'foo@example.com') }
    let(:resource) { Userlist::Push::User.from_payload(user, config) }

    context 'for identifier' do
      it 'should use the model\'s userlist_identifier' do
        user.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
        expect(resource.identifier).to eq('custom_identifier')
      end

      it 'should use the model\'s name and id as fallback' do
        expect(resource.identifier).to eq('user-1')
      end

      context 'when the user is destroyed' do
        before { user.destroy! }

        it 'should not use the model\'s userlist_identifier' do
          user.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
          expect(resource.identifier).to eq(nil)
        end

        it 'should return nothing' do
          expect(resource.identifier).to eq(nil)
        end
      end
    end

    context 'for identifiers' do
      it 'should not use the model\'s userlist_identifiers' do
        user.define_singleton_method(:userlist_identifiers) { [{ scope: 'custom', identifier: 'custom_identifier' }] }
        expect(resource.identifiers).to eq(nil)
      end

      it 'should use nothing as fallback' do
        expect(resource.identifiers).to eq(nil)
      end

      context 'when the user is destroyed' do
        before { user.destroy! }

        it 'should use the model\'s userlist_identifiers' do
          user.define_singleton_method(:userlist_identifiers) { [{ scope: 'custom', identifier: 'custom_identifier' }] }
          expect(resource.identifiers).to eq([{ scope: 'custom', identifier: 'custom_identifier' }])
        end

        it 'should use the identfier as fallback' do
          expect(resource.identifiers).to eq([{ scope: 'custom', identifier: 'user-1' }])
        end

        it 'should respect a customized identifier as fallback' do
          user.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
          expect(resource.identifiers).to eq([{ scope: 'custom', identifier: 'custom_identifier' }])
        end
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

    describe '#push?' do
      it 'should return true by default' do
        expect(resource.push?).to eq(true)
      end

      it 'should return the value of the userlist_push? method' do
        user.define_singleton_method(:userlist_push?) { false }
        expect(resource.push?).to eq(false)
      end
    end

    describe '#delete?' do
      it 'should return false by default' do
        expect(resource.delete?).to eq(true)
      end

      it 'should return the value of the userlist_delete? method' do
        user.define_singleton_method(:userlist_delete?) { false }
        expect(resource.delete?).to eq(false)
      end
    end
  end
end
