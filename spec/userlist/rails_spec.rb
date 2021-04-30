require 'spec_helper'

RSpec.describe Userlist::Rails do
  describe '.setup_callbacks' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        self.table_name = :users
      end
    end

    let(:relation) { double('relation') }

    before do
      allow(Userlist::Push).to receive(:users).and_return(relation)
      allow(relation).to receive(:push)
      allow(relation).to receive(:delete)

      described_class.setup_callbacks(model_class, :users)
    end

    context 'when the user is created' do
      it 'should push the user' do
        expect(Userlist::Push.users).to receive(:push).with(an_instance_of(model_class))
        model_class.create
      end
    end

    context 'when the user is updated' do
      it 'should push the user' do
        model = model_class.create
        expect(Userlist::Push.users).to receive(:push).with(model)
        model.save
      end
    end

    context 'when the user is destroyed' do
      it 'should delete the user' do
        model = model_class.create
        expect(Userlist::Push.users).to receive(:delete).with(model)
        model.destroy
      end
    end

    context 'when the callbacks are set up multiple times' do
      before { described_class.setup_callbacks(model_class, :users) }

      it 'should not add additional callbacks' do
        expect(Userlist::Push.users).to receive(:push).with(an_instance_of(model_class)).once
        model_class.create
      end
    end
  end

  describe '.detect_relationship' do
    context 'when it is a has many through relationship' do
      let(:scope) { HasManyThrough }

      it 'should detect the relationship model between to other models' do
        relationship = described_class.detect_relationship(scope::User, scope::Company)
        expect(relationship).to eq(scope::Membership)
      end
    end

    context 'when it is a has and belongs to many relationship' do
      let(:scope) { HasAndBelongsToMany }

      it 'should not detect a relationship model between to other models' do
        relationship = described_class.detect_relationship(scope::User, scope::Company)
        expect(relationship).to eq(nil)
      end
    end

    context 'when it is a has many relationship' do
      let(:scope) { HasManyCompanies }

      it 'should not detect a relationship model between to other models' do
        relationship = described_class.detect_relationship(scope::User, scope::Company)
        expect(relationship).to eq(nil)
      end
    end

    context 'when it is a has one relationship' do
      let(:scope) { HasOneCompany }

      it 'should not detect a relationship model between to other models' do
        relationship = described_class.detect_relationship(scope::User, scope::Company)
        expect(relationship).to eq(nil)
      end
    end

    context 'when it is a belongs to relationship' do
      let(:scope) { HasManyUsers }

      it 'should not detect a relationship model between to other models' do
        relationship = described_class.detect_relationship(scope::User, scope::Company)
        expect(relationship).to eq(nil)
      end
    end
  end
end
