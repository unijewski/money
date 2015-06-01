class Exchange
  class InvalidCurrency < StandardError; end

  CURRENCIES = %w(USD EUR GBP CHF JPY PLN)

  def convert(money, currency_out)
    currency_out.upcase!
    currency_in = money.currency

    currencies_valid?(currency_in, currency_out)

    exchange = fetch_rate(currency_in, currency_out).values.first.to_s
    BigDecimal.new(exchange) * money.amount
  end

  private

  def currencies_valid?(*args)
    result = args - CURRENCIES
    if !result.empty?
      fail InvalidCurrency, "#{result.first}"
    else
      true
    end
  end

  def fetch_rate(currency_in, currency_out)
    CurrencyConverter.get(
      '/convert', query: { q: "#{currency_in}_#{currency_out}", compact: 'ultra' }
    ).parsed_response
  end
end
