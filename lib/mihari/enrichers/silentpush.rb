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
        res = client.query(artifact.data)
        Mihari.logger.info(res.inspect)

        artifact.tap do |tapped|
          domain_info = res.result&.domain_info
          if domain_info

            tapped.whois_record ||= Models::WhoisRecord.new(
              domain: domain_info.domain,
              registrar: {entity: domain_info.registrar},
              created_on: Date.parse(domain_info.whois_created_date),
              updated_on: Date.parse(domain_info.last_seen&.to_s)
            )
          end
        end
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
