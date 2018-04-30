require 'bigdecimal'

class ExchangeRate
  @config = { provider: nil, data_source_path: nil }
  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  def self.at(exchanged_on, base_currency, counter_currency)
    ExchangeRate::Calculation
      .with(provider)
      .from(base_currency)
      .to(counter_currency)
      .on(exchanged_on)
      .execute
  end

  private

  def provider
    @provider ||= create_provider
  end

  def create_provider
    unless valid_provider? config[:provider]
      raise Error::Configuration, "Invalid Exchange Rate provider configured"
    end

    config[:provider].new config[:data_source_path]
  end

  def valid_provider?(provider)
    provider.respond_to?(:has_records_until, :base_currency, :exchange_rate_for)
  end
end
