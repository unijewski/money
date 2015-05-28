require 'spec_helper'

describe Exchange do
  subject { Money.exchange }

  describe '#convert' do
    context 'when currencies are valid' do
      it 'should calculate the result' do
        expect(subject.convert(Money(10, 'USD'), 'EUR')).to eq 9.211
      end
    end

    context 'when at least one of currencies is not valid' do
      it 'should raise an error' do
        expect do
          subject.convert(Money(10, 'USD'), 'whatever')
        end.to raise_error(Exchange::InvalidCurrency, 'whatever')
      end
    end
  end
end
