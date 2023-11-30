require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Company do
  describe '.from_payload' do
    let(:config) { Userlist.config.merge(company_model: Company) }
    let(:company) { Company.create(name: 'Foo, Inc.') }
    let(:resource) { Userlist::Push::Company.from_payload(company, config) }

    context 'for identifier' do
      it 'should use the model\'s userlist_identifier' do
        company.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
        expect(resource.identifier).to eq('custom_identifier')
      end

      it 'should use the model\'s name and id as fallback' do
        expect(resource.identifier).to eq('company-1')
      end
    end

    context 'for name' do
      it 'should use the model\'s userlist_name' do
        company.define_singleton_method(:userlist_name) { 'Custom, Inc.' }
        expect(resource.name).to eq('Custom, Inc.')
      end

      it 'should use the model\'s name as fallback' do
        expect(resource.name).to eq('Foo, Inc.')
      end
    end

    context 'for properties' do
      it 'should use the model\'s userlist_properties' do
        company.define_singleton_method(:userlist_properties) { { foo: :bar } }
        expect(resource.properties).to eq({ foo: :bar })
      end

      it 'should use an empty hash as fallback' do
        expect(resource.properties).to eq({})
      end
    end

    context 'for signed_up_at' do
      it 'should use the model\'s created_at' do
        expect(resource.signed_up_at).to eq(company.created_at)
      end
    end

    describe '#push?' do
      it 'should return true by default' do
        expect(resource.push?).to eq(true)
      end

      it 'should return the value of the userlist_push? method' do
        company.define_singleton_method(:userlist_push?) { false }
        expect(resource.push?).to eq(false)
      end
    end

    describe '#delete?' do
      it 'should return false by default' do
        expect(resource.delete?).to eq(true)
      end

      it 'should return the value of the userlist_delete? method' do
        company.define_singleton_method(:userlist_delete?) { false }
        expect(resource.delete?).to eq(false)
      end
    end
  end
end
