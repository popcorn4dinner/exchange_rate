require 'bigdecimal'

module ExchangeRate
  module Providers
    class Ecb

      def initialize(data_source_path, data = nil)
        @data_source_path = data_source_path
        @data = data
      end

      def base_currency
        "EUR"
      end

      def has_records_until
        Date.parse data.search('Cube Cube[time]').last[:time]
      end

      def exchange_rate_for(currency, exchanged_on)
        rate = data.search(
          "Cube Cube[time=\"#{exchanged_on}\"] Cube[currency=#{currency}]"
        ).first[:rate]

        BigDecimal(rate)
      end

      private

      def data
        @data ||= File.open(@data_source_path) { |f| Nokogiri::XML(f) }
      end
    end
  end
end

