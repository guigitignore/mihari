module Mihari
  module Enrichers
    #
    # SilentPush enricher
    #
    class SilentPush < Base
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      def call(artifact)
        Mihari.logger.info(artifact.inspect)

        res = case artifact.data_type
        when "domain" then client.query_domain(artifact.data)
        end

        Mihari.logger.info(res.inspect)

        res.result&.domain_info.tap do |domain_info|
          if domain_info.registrar != "" && domain_info.whois_created_date != ""
            artifact.whois_record ||= Models::WhoisRecord.new(
              domain: domain_info.domain,
              registrar: {organization: domain_info.registrar},
              created_on: Date.parse(domain_info.first_seen&.to_s || DateTime.now.to_s),
              updated_on: Date.parse(domain_info.last_seen&.to_s || DateTime.now.to_s),
              contacts: {},
              created_at: DateTime.parse(domain_info.whois_created_date)
            )
          end
        end

        artifact
      end

      private

      def callable_relationships?(artifact)
        artifact.whois_record.nil?
      end

      def supported_data_types
        %w[domain]
      end

      def client
        @client ||= Clients::SilentPush.new(key: Mihari.config.silentpush_api_key)
      end
    end
  end
end
