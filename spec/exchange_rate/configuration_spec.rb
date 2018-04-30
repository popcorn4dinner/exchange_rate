require 'spec_helper'

require 'exchange_rate/providers/ecb'
require 'exchange_rate/errors/configuration'
require 'exchange_rate/configuration'

describe ExchangeRate do
  before(:each) do
    @provider = ExchangeRate::Providers::Ecb.new "some/path"
    @config = ExchangeRate::Configuration.new
  end

  context "should throw exception when" do

    it "no data_source_path is given" do
      expect { @config.data_source_path }.to raise_error(ExchangeRate::Errors::Configuration)
    end

    it "no data_source_path is given" do
      expect { @config.provider }.to raise_error(ExchangeRate::Errors::Configuration)
    end
  end

  context "not complain when" do
    it "a proper provider is given" do
      @config.provider = @provider
      expect( @config.provider ).to be(@provider)
    end

    it "a data_source_path is given" do
      @config.data_source_path = "/some/path"
      expect( @config.data_source_path ).to eq("/some/path")
    end
  end
end

