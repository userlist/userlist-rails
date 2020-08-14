require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Company do
  let(:resource_type) do
    type = Class.new(Userlist::Push::Company)
    type.extend(described_class)
    type
  end

  describe '.from_payload' do
    let(:config) { Userlist.config.merge(company_model: Company) }
    let(:company) { Company.new(1234, 'Foo, Inc.', Time.now) }
    let(:resource) { resource_type.from_payload(company, config) }

    context 'for identifier' do
      it 'should use the model\'s userlist_identifier' do
        company.define_singleton_method(:userlist_identifier) { 'custom_identifier' }
        expect(resource.identifier).to eq('custom_identifier')
      end

      it 'should use the model\'s name and id as fallback' do
        expect(resource.identifier).to eq('company-1234')
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
  end
end
