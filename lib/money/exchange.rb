require 'json'

class Exchange
  class InvalidCurrency < StandardError; end

  CURRENCIES = %w(USD EUR GBP CHF JPY PLN)

  def convert(money, currency_out)
    currency_out.upcase
    currency_in = money.currency

    currencies_valid?(currency_in, currency_out)

    exchange = rates["#{currency_in}_#{currency_out}"]
    BigDecimal.new(exchange.to_s) * money.amount
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

  def rates
    file = File.read(Pathname(__FILE__).dirname + 'rates.json')
    JSON.parse(file)
  end
end
