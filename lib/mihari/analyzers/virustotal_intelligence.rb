# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # VirusTotal Intelligence analyzer
    #
    class VirusTotalIntelligence < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nll] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.virustotal_api_key
      end

      def artifacts
        client.intel_search_with_pagination(query, pagination_limit: pagination_limit).map(&:artifacts).flatten
      end

      class << self
        def configuration_keys
          %w[virustotal_api_key]
        end
      end

      class << self
        #
        # @return [String]
        #
        def class_key
          "virustotal_intelligence"
        end

        #
        # @return [Array<String>, nil]
        #
        def class_key_aliases
          ["vt_intel"]
        end
      end

      private

      #
      # VT API
      #
      # @return [::VirusTotal::API]
      #
      def client
        Clients::VirusTotal.new(
          api_key: api_key,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
      end
    end
  end
end
