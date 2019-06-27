require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Event do
  let(:resource_type) do
    type = Class.new(Userlist::Push::Event)
    type.include(described_class)
    type
  end

  let(:model) { Struct.new(:userlist_payload) }

  it 'should use the current user when none is given' do
    user = model.new(identifier: 'user-identifier')

    resource = Userlist::Rails.with_current_user(user) do
      resource_type.new(name: 'custom_event')
    end

    expect(resource.attributes).to match(hash_including(user: user))
  end
end
