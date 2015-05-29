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

  describe '#<=>' do
    it { expect(subject < Money(10, 'EUR')).to eq true }
    it { expect(subject > Money(10, 'EUR')).to eq false }
    it { expect(Money(10_000, 'USD') == Money(9211, 'EUR')).to eq true }
  end

  describe '.using_default_currency' do
    context 'when we create a new instance inside the block' do
      it 'should create the instance' do
        expect(Money.using_default_currency('usd') { Money.new(10) }).to be_an_instance_of Money
        expect(Money.using_default_currency('usd') { Money(10) }).to be_an_instance_of Money
      end
    end

    context 'when we create a new instance without the block' do
      it 'should raise an error' do
        expect { Money.new(10) }.to raise_error ArgumentError
        expect { Money(10) }.to raise_error ArgumentError
      end
    end
  end

  describe '#method_missing' do
    context 'when a currency exists' do
      it 'should not raise an error' do
        expect { subject.to_eur }.not_to raise_error
      end
    end

    context 'when a currency does not exist' do
      it 'should raise an error' do
        expect { subject.to_asd }.to raise_error NoMethodError
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
