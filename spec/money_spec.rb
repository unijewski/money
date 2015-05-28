require 'spec_helper'

describe Money do
  subject { described_class.new(10, 'USD') }

  describe '#to_s' do
    it { expect(subject.to_s).to eq '10.00 USD' }
  end

  describe '#inspect' do
    it { expect(subject.inspect).to eq '#<Money 10.00 USD>' }
  end

  describe '.from_<currency>' do
    it 'should create an instance of Money class' do
      money = described_class.from_eur(10)
      expect(money).to be_an_instance_of Money
    end
  end

  describe '#exchange_to' do
    context 'when given currency is valid' do
      it 'should create a new instance' do
        expect(subject.exchange_to('EUR').inspect).to eq '#<Money 9.21 EUR>'
      end
    end

    context 'when given currency is not valid' do
      it 'should raise an error' do
        expect do
          subject.exchange_to('whatever').inspect
        end.to raise_error(Exchange::InvalidCurrency, 'whatever')
      end
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
