require 'spec_helper'
require 'userlist/config'

RSpec.describe Userlist::Rails::Helpers, type: :helper do
  let(:config) { Userlist.config.merge(user_model: User) }

  let(:user) { User.new('identifer') }

  shared_examples 'a valid script tag' do
    it 'should return a script tag' do
      expect(subject).to match(%{<script[^>]*></script>})
    end

    it 'should initialize the queue' do
      expect(subject).to match(/window\.userlist/)
    end

    it 'should be marked as async' do
      expect(subject).to match(/async/)
    end

    it 'should include the script url' do
      expect(subject).to match(/src="#{config.script_url}"/)
    end
  end

  shared_examples 'a script tag with a token' do
    it 'should include the token' do
      expect(subject).to match(/data-userlist="#{token}"/)
    end
  end

  shared_examples 'a script tag without a token' do
    it 'should not include the token' do
      expect(subject).to_not match(/data-userlist="[^"]*"/)
    end
  end

  context 'when the configuration is valid' do
    let(:config) { super().merge(push_key: 'push-key', push_id: 'push-id') }

    before do
      allow(Userlist).to receive(:config).and_return(config)
    end

    context 'when no user is given' do
      subject { helper.userlist_script_tag }

      context 'when there is a current user method' do
        before do
          allow(helper).to receive(:current_user).and_return(user)
        end

        it_behaves_like 'a valid script tag'
        it_behaves_like 'a script tag with a token' do
          let(:token) { Userlist::Token.generate(user) }
        end
      end

      context 'when there is no current user method' do
        it_behaves_like 'a valid script tag'
        it_behaves_like 'a script tag without a token'
      end
    end

    context 'when a user is given' do
      subject { helper.userlist_script_tag(user) }

      it_behaves_like 'a valid script tag'
      it_behaves_like 'a script tag with a token' do
        let(:token) { Userlist::Token.generate(user) }
      end

      context 'when there is a current user method' do
        let(:other) { double(:user, userlist_identifier: 'other-identifer') }

        before do
          allow(helper).to receive(:current_user).and_return(other)
        end

        it_behaves_like 'a valid script tag'
        it_behaves_like 'a script tag with a token' do
          let(:token) { Userlist::Token.generate(user) }
        end
      end
    end
  end

  context 'when the configuration is invalid' do
    let(:config) { super().merge(push_key: nil, push_id: nil) }
    let(:logger) { TestLogger.new }

    before do
      allow(Userlist).to receive(:config).and_return(config)
      allow(Userlist).to receive(:logger).and_return(logger)
    end

    it 'should log the error message' do
      helper.userlist_script_tag(user)
      expect(logger.messages).to match(/push_key/)
    end

    context 'when the environment is production' do
      subject { helper.userlist_script_tag(user) }

      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
      end

      it 'should return nothing' do
        expect(subject).to_not be
      end
    end

    context 'when the environment is not production' do
      subject { helper.userlist_script_tag(user) }

      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
      end

      it 'should return a comment with the error message' do
        expect(subject).to match(/<!--.+push_key.+-->/m)
      end
    end
  end
end
