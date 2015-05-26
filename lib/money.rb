require 'money/version'
require 'pry'

class Money
  attr_accessor :amount, :currency

  CURRENCIES = %w(usd eur gbp)

  def initialize(amount, currency)
    @amount, @currency = amount, currency
  end

  def to_s
    precise_amount + ' ' + currency
  end

  def inspect
    "#<Money #{self.to_s}>"
  end

  CURRENCIES.each do |currency|
    define_singleton_method("from_#{currency}") do |argument|
      new(argument, currency.upcase)
    end
  end

  private

  def precise_amount
    '%.2f' % amount
  end
end

def Money(amount, currency)
  Money.new(amount, currency)
end
