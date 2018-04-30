require 'spec_helper'
require 'date'

describe ExchangeRate do
  it "should return the changerate for known currencies" do
    expect(ExchangeRate.at(Date.today, 'EUR', 'SEK')).to be_a(String)
  end
end
