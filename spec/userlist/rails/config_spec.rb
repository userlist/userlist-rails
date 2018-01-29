require 'spec_helper'
require 'userlist/config'

RSpec.describe Userlist::Rails::Config do
  subject { Userlist::Config.new }

  before { ENVCache.start! }
  after { ENVCache.stop! }

  it 'should prepend itself in the Userlist::Config' do
    expect(Userlist::Config.ancestors).to include(described_class)
  end

  describe '#auto_discover' do
    it 'should have a default value' do
      expect(subject.auto_discover).to eq(true)
    end

    it 'should accept values from the ENV' do
      ENV['USERLIST_AUTO_DISCOVER'] = 'false'
      expect(subject.auto_discover).to eq(false)
    end

    it 'should accept values via the setter' do
      subject.auto_discover = 'false'
      expect(subject.auto_discover).to eq(false)
    end
  end

  describe '#user_model' do
    it 'should have a default value' do
      expect(subject.user_model).to_not be
    end

    it 'should accept values from the ENV' do
      ENV['USERLIST_USER_MODEL'] = 'User'
      expect(subject.user_model).to eq(User)
    end

    it 'should accept values via the setter' do
      subject.user_model = 'User'
      expect(subject.user_model).to eq(User)
    end
  end

  describe '#company_model' do
    it 'should have a default value' do
      expect(subject.company_model).to_not be
    end

    it 'should accept values from the ENV' do
      ENV['USERLIST_COMPANY_MODEL'] = 'Company'
      expect(subject.company_model).to eq(Company)
    end

    it 'should accept values via the setter' do
      subject.company_model = 'Company'
      expect(subject.company_model).to eq(Company)
    end
  end
end
