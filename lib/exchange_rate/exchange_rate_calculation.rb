module ExchangeRate
  class Calculation
    @exchanged_on = Date.today

    def self.with(provider)
      @provider = provider
      self
    end

    def self.from(currency)
      @from = currency
      self
    end

    def self.to(currency)
      @to = currency
      self
    end

    def self.on(exchanged_on)
      @exchanged_on = exchanged_on
      self
    end

    def self.execute
      unless within_allowed_timeframe?(@exchanged_on)
        raise Errors::InvalidExchangeDate "#{@exchanged_on} is unavailable or in the future."
      end

      exchange_rate_for(@from, @exchanged_on) * exchange_rate_for(@to, @exchanged_on)
    end

    private

    def exchange_rate_for(currency, exchanged_on)
      needs_exchange? ? @provider.exchange_rate_for(currency, exchanged_on) : 1
    end

    def needs_exchange?(currency)
      @provider.base_currency == currency
    end

    def within_allowed_timeframe?(exchanged_on)
      exchanged_on.between?(@provider.has_records_until, Date.today)
    end
  end
end
