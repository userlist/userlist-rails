require 'spec_helper'

RSpec.describe Userlist::Rails::Extensions::Event do
  let(:config) { Userlist.config.merge(user_model: User, company_model: Company) }

  let(:user) { User.new('identifier') }
  let(:company) { Company.new('identifier') }

  it 'should use the current user when none is given' do
    resource = Userlist::Rails.with_current_user(user) do
      Userlist::Push::Event.new({ name: 'custom_event' }, config)
    end

    expect(resource.user.identifier).to eq('user-identifier')
  end

  it 'should use the current company when none is given' do
    resource = Userlist::Rails.with_current_company(company) do
      Userlist::Push::Event.new({ name: 'custom_event' }, config)
    end

    expect(resource.company.identifier).to eq('company-identifier')
  end
end
