require 'money/version'
require 'money/exchange'

class Money
  include Comparable

  attr_accessor :amount, :currency

  CURRENCIES = %w(usd eur gbp)

  def initialize(amount, currency)
    @amount = amount
    @currency = currency.upcase
  end

  def to_s
    precise_amount + ' ' + currency
  end

  def inspect
    "#<Money #{self}>"
  end

  CURRENCIES.each do |currency|
    define_singleton_method("from_#{currency}") do |argument|
      new(argument, currency)
    end
  end

  def self.exchange
    Exchange.new
  end

  def exchange_to(currency)
    self.amount = Money.exchange.convert(self, currency)
    self.currency = currency
    self
  end

  def <=>(other)
    exchange_to(other.currency).amount <=> other.amount
  end

  private

  def precise_amount
    format('%.2f', amount)
  end
end

def Money(amount, currency)
  Money.new(amount, currency)
end
