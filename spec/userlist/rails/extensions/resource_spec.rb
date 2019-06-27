require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Resource do
  let(:resource_type) do
    type = Class.new(Userlist::Push::Resource)
    type.include(described_class)
    type
  end

  let(:model) { Struct.new(:userlist_payload) }

  it 'should transform compatible objects into hashes' do
    company = model.new(identifier: 'company-identifier')
    user = model.new(identifier: 'user-identifier', company: company)

    resource = resource_type.new(user)

    expect(resource.attributes).to eq(
      identifier: 'user-identifier',
      company: {
        identifier: 'company-identifier'
      }
    )
  end
end
