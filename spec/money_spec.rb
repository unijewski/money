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
    money = described_class.from_eur(10)
    it { expect(money).to be_an_instance_of Money  }
    it { expect(money.to_s).to eq '10.00 EUR' }
  end
end
