require 'spec_helper'

describe Money::Exchange do
  subject { Money.exchange }

  before do
    file = Pathname(__FILE__).dirname + 'fixtures/rates.json'
    response_body = File.read(file)

    stub_request(:get, 'http://www.freecurrencyconverterapi.com/api/v3/convert')
      .with(query: { q: 'USD_EUR', compact: 'ultra' })
      .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
  end

  describe '#convert' do
    context 'when currencies are valid' do
      it 'should calculate the result' do
        expect(subject.convert(Money(10, 'USD'), 'EUR')).to eq BigDecimal('9.211')
      end
    end

    context 'when at least one of currencies is not valid' do
      it 'should raise an error' do
        expect do
          subject.convert(Money(10, 'USD'), 'whatever')
        end.to raise_error(Money::Exchange::InvalidCurrency, 'WHATEVER')
      end
    end
  end
end
