require 'spec_helper'

require 'date'

require 'exchange_rate/providers/ecb'
require 'exchange_rate/errors/invalid_currency'
require 'exchange_rate/errors/invalid_exchange_date'

describe ExchangeRate do
  before(:each) do

    provider = ExchangeRate::Providers::Ecb

    allow_any_instance_of(provider).to receive(:base_currency).and_return("EUR")
    allow_any_instance_of(provider).to receive(:has_records_until).and_return(Date.today - 1)
    allow_any_instance_of(provider).to receive(:exchange_rate_for)
                             .with("SEK", an_instance_of(Date))
                             .and_return(BigDecimal("10.4"))
    allow_any_instance_of(provider).to receive(:exchange_rate_for)
                             .with("NOK", an_instance_of(Date))
                             .and_return(BigDecimal("1.22"))

    allow_any_instance_of(provider).to receive(:exchange_rate_for)
                             .with("EUR", an_instance_of(Date))
                             .and_raise(ExchangeRate::Errors::InvalidCurrency)

    allow_any_instance_of(provider).to receive(:exchange_rate_for)
                                         .with("XXX", an_instance_of(Date))
                                         .and_raise(ExchangeRate::Errors::InvalidCurrency)


    ExchangeRate.configure do |c|
      c.provider = provider
      c.data_source_path = "some/path/to/data.xml"
    end
  end

  context "calculating the correct change rate" do

    it "should calculate from base_currency" do
      expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to eq(BigDecimal("0.104e2"))
    end

    it "should calculate from exchanging to base_currency" do
      expect(ExchangeRate.at(Date.today, 'SEK', 'EUR')).to eq(BigDecimal("0.96153846153846153846153846e-1"))
    end

    it "should calculate when exchanging between non-base-currencies" do
      expect(ExchangeRate.at(Date.today, 'NOK', 'SEK')).to eq(BigDecimal("0.85245901639344262295081967312e1"))
    end

  end

  it "should throw an exception for unknown currencies" do
    expect {ExchangeRate.at(Date.today, 'XXX', 'SEK')}.to raise_error(ExchangeRate::Errors::InvalidCurrency)
  end

   context "should only accept exchange dates within the allowed time frame" do

    it "should accept requests for valid date range" do
      expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to be_a(BigDecimal)
      expect(ExchangeRate.at(Date.today - 1, 'EUR', 'SEK')).to be_a(BigDecimal)
    end

    it "should not accept dates in the future" do
      expect { ExchangeRate.at(Date.today + 1, 'EUR', 'SEK') }.to raise_error(ExchangeRate::Errors::InvalidExchangeDate)
    end

    it "should not accept dated older the provided" do
      expect { ExchangeRate.at(Date.today - 2, 'EUR', 'SEK') }.to raise_error(ExchangeRate::Errors::InvalidExchangeDate)
    end

  end

end

