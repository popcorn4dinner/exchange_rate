require 'exchange_rate/errors/configuration'

module ExchangeRate
  class Configuration
    attr_writer :provider, :data_source_path

    def initialize
      @provider = nil
      @data_source_path = nil
    end

    def provider
        raise Errors::Configuration, "Invalid Exchange Rate provider configured" unless @provider
      @provider
    end

    def data_source_path
      raise Errors::Configuration, "data source path is not set" unless @data_source_path
      @data_source_path
    end

  end
end
