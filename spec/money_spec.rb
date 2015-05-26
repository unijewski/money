require 'spec_helper'

describe Money do
  subject { described_class.new(10, 'USD') }

  describe '#to_s' do
    it { expect(subject.to_s).to eq '10.00 USD' }
  end

  describe '#inspect' do
    it { expect(subject.inspect).to eq '#<Money 10.00 USD>'}
  end

  describe '.from_<currency>' do
    it 'should create an instance of Money class' do
      money = described_class.from_eur(10)
      expect(money).to be_an_instance_of Money
    end
  end

  describe '#Money' do
    it 'should create a Money object' do
      money = Money(10, 'PLN')
      expect(money).to be_an_instance_of Money
      expect(money.to_s).to eq '10.00 PLN'
    end
  end
end
