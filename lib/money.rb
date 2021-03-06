require 'money/exchange'
require 'money/currency_converter'
require 'money/kernel'
require 'bigdecimal'

class Money
  include Comparable

  class << self
    attr_accessor :default_currency
  end

  attr_accessor :amount, :currency

  CURRENCIES = %w(usd eur gbp jpy)

  def initialize(amount, currency = Money.default_currency)
    fail ArgumentError if currency.nil?

    @amount = BigDecimal.new(amount.to_s)
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

  def self.using_default_currency(currency)
    initial_value = default_currency
    self.default_currency = currency
    object = yield
  ensure
    self.default_currency = initial_value
    object
  end

  def method_missing(method_name)
    fail NoMethodError unless method_name.to_s.start_with?('to_')
    currency = method_name.to_s.split('_').last
    if CURRENCIES.include? currency
      exchange_to(currency.upcase)
    else
      fail NoMethodError
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('to_') || super
  end

  [:+, :-].each do |method|
    define_method(method) do |arg|
      self.amount = amount.public_send(method, arg.exchange_to(currency).amount)
      self
    end
  end

  [:*, :/].each do |method|
    define_method(method) do |arg|
      self.amount = amount.public_send(method, arg)
      self
    end
  end

  private

  def precise_amount
    format('%.2f', amount)
  end
end
