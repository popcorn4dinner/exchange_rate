require 'spec_helper'

require 'date'
require 'nokogiri'

require 'exchange_rate/providers/ecb'
require 'exchange_rate/errors/invalid_currency'

describe ExchangeRate do
  before(:each) do
    @data = Nokogiri::XML("")
    @provider = ExchangeRate::Providers::Ecb.new "/some/path", @data
  end

  context "respect the ECB data source constrains by" do
    it "providing records until 90 days ago" do
      allow(@data).to receive(:search).and_return([{time: '2018-01-29'}])
      expect(@provider.has_records_until).to be_a(Date)
      expect(@provider.has_records_until).to eq(Date.parse('2018-01-29'))
    end

    it "unsing EUR as base_currency" do
      expect(@provider.base_currency).to eq("EUR")
      expect(@provider.base_currency).to be_a(String)
    end
  end

  it "should return the right type for exchange rates" do
    allow(@data).to receive(:search).and_return([{rate: '1.22'}])
    expect(@provider.exchange_rate_for("USD", Date.today)).to be_a(BigDecimal)
  end
end

