require 'bigdecimal'
require 'exchange_rate/configuration'
require 'exchange_rate/calculation'

module ExchangeRate
  class << self
    attr_accessor :configuration

    def at(exchanged_on, base_currency, counter_currency)
      ExchangeRate::Calculation
        .new(provider)
        .execute(
          from: base_currency,
          to: counter_currency,
          exchanged_on: exchanged_on
        )
    end

    private

    def provider
      @provider ||= create_provider
    end

    def create_provider
      configuration.provider.new configuration.data_source_path
    end
  end

  def self.configuration
    @configuration ||= ExchangeRate::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
