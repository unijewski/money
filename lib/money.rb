require 'money/version'

class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount, @currency = amount, currency
  end

  def to_s
    precise_amount + ' ' + currency
  end

  def inspect
    "#<Money #{self.to_s}>"
  end

  private

  def precise_amount
    '%.2f' % amount
  end
end
