require 'spec_helper'

RSpec.describe Userlist::Rails::Logger do
  subject { described_class.new(logger, config) }

  let(:logger) { TestLogger.new }
  let(:config) { {} }

  it { should respond_to(:fatal) }
  it { should respond_to(:error) }
  it { should respond_to(:warn) }
  it { should respond_to(:info) }
  it { should respond_to(:debug) }

  it 'should forward log messages to the given logger' do
    expect(logger).to receive(:add).with(Logger::ERROR, '[userlist-rails] Error', 'progname')
    subject.error('Error', 'progname')
  end

  it 'should respect the log level from the config' do
    config[:log_level] = :warn
    subject.error('Error')
    subject.debug('Debug')

    expect(logger.messages).to match(/Error/)
    expect(logger.messages).to_not match(/Debug/)
  end

  it 'should tag all messages with the gem name' do
    subject.error('Testing')
    expect(logger.messages).to match(/\[userlist-rails\] Testing/)
  end
end
