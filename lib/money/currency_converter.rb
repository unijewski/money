require 'httparty'

class Money
  class CurrencyConverter
    include HTTParty

    base_uri 'http://www.freecurrencyconverterapi.com/api/v3'
  end
end
