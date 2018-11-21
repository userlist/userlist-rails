require 'spec_helper'

RSpec.describe Userlist::Rails::Push do
  subject { Userlist::Push.new(push_strategy: strategy) }

  let(:strategy) { instance_double('Userlist::Push::Strategies::Direct') }

  before do
    subject.singleton_class.include(described_class)
  end

  let(:model) do
    Struct.new(:userlist_payload)
  end

  describe '#user' do
    it 'should transform company records into attributes' do
      company = model.new(identifier: 'company-identifier')

      expect(strategy).to receive(:call).with(:post, '/users', hash_including(company: { identifier: 'company-identifier' }))
      subject.user(identifier: 'user-identifier', company: company)
    end
  end

  describe '#event' do
    it 'should transform user records into attributes' do
      user = model.new(identifier: 'user-identifier')

      expect(strategy).to receive(:call).with(:post, '/events', hash_including(user: { identifier: 'user-identifier' }))
      subject.event(name: 'foo', user: user)
    end

    it 'should transform nested company records into attributes' do
      company = model.new(identifier: 'company-identifier')
      user = model.new(identifier: 'user-identifier', company: company)

      expect(strategy).to receive(:call).with(:post, '/events', hash_including(user: { identifier: 'user-identifier', company: { identifier: 'company-identifier' } }))
      subject.event(name: 'foo', user: user)
    end
  end
end
