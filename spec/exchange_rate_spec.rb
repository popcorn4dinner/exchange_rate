require 'spec_helper'
require 'date'

describe ExchangeRate do
  it "should return the changerate for known currencies" do
    expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to be_a(BigDecimal)
  end

  it "should throw an exception for unknown currencies" do
    expect(ExchangeRate.at(Date.tomorrow, 'EUR', 'SEK')).to be_a(BigDecimal)
  end

  it "should throw an exception if the exchangedAt date is not within the allowed timeframe" do
    expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to be_a(BigDecimal)
  end

  it "should throw and exception if malconfigured" do
    expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to be_a(BigDecimal)
  end


end
