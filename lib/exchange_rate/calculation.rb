require 'date'
require 'exchange_rate/errors/invalid_exchange_date'

module ExchangeRate
  class Calculation

    def initialize(provider)
      @provider = provider
    end

    def execute(from:, to:, exchanged_on:)
      unless within_allowed_timeframe?(exchanged_on)
        raise ExchangeRate::Errors::InvalidExchangeDate, "#{exchanged_on} is unavailable or in the future."
      end

      calculate_exchange_rate_with(from, to, exchanged_on)
    end

    private

    def calculate_exchange_rate_with(from, to, exchanged_on)
      (1 / exchange_rate_for(from, exchanged_on)) * exchange_rate_for(to, exchanged_on)
    end

    def exchange_rate_for(currency, exchanged_on)
      needs_exchange?(currency) ? @provider.exchange_rate_for(currency, exchanged_on) : 1
    end

    def needs_exchange?(currency)
      @provider.base_currency != currency
    end

    def within_allowed_timeframe?(exchanged_on)
      exchanged_on.between?(@provider.has_records_until, Date.today)
    end
  end
end
