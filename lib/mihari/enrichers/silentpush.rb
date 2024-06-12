module Mihari
  module Enrichers
    #
    # SilentPush enricher
    #
    class SilentPush < Base
      #
      # @param [Mihari::Models::Artifact] artifact
      # @param [Mihari::Structs::SilentPush::ScanData] scan_data
      #
      def parse_scan_data(artifact, scan_data)
        artifact.certificates += scan_data.certificates.map do |certificate|
          # we gather all domains from different fields into a single array
          # see https://docs.silentpush.com/enrich.html
          domains = []
          domains << certificate.domain unless certificate.domain.empty?
          domains += certificate.domains
          domains << certificate.hostname unless certificate.hostname.nil? || certificate.hostname.empty?

          Models::Certificate.new(
            domains: domains.uniq.join(","),
            fingerprint_sha1: certificate.fingerprint_sha1,
            ip: certificate.ip,
            is_expired: certificate.is_expired,
            issuer_common_name: certificate.issuer_common_name,
            issuer_organization: certificate.issuer_organization,
            not_after: certificate.not_after.empty? ? nil : DateTime.parse(certificate.not_after),
            not_before: certificate.not_before.empty? ? nil : DateTime.parse(certificate.not_before),
            created_at: DateTime.parse(certificate.scan_date)
          )
        end
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      def call(artifact)
        # actually support only domains and IPv4
        res = client.query(artifact.data_type, artifact.data)

        artifact.tap do |tapped|
          res.result.domain_info&.yield_self do |domain_info|
            # scan_data is not located in the same field depending on data type
            parse_scan_data(tapped, res.result.scan_data)

            unless domain_info.registrar.empty? || domain_info.whois_created_date.empty?
              tapped.whois_record ||= Models::WhoisRecord.new(
                domain: domain_info.domain,
                registrar: {name: domain_info.registrar},
                created_on: Date.parse(domain_info.first_seen&.to_s || DateTime.now.to_s),
                updated_on: Date.parse(domain_info.last_seen&.to_s || DateTime.now.to_s),
                contacts: {},
                created_at: DateTime.parse(domain_info.whois_created_date)
              )
            end
          end

          res.result.ip2asn.map do |ip2asn|
            tapped.autonomous_system ||= Models::AutonomousSystem.new(number: ip2asn.asn)
            parse_scan_data(tapped, ip2asn.scan_data)

            unless ip2asn.ip_location.nil?
              tapped.geolocation ||= Models::Geolocation.new(
                country: ip2asn.ip_location.country_name,
                country_code: ip2asn.ip_location.country_code,
                created_at: DateTime.parse(ip2asn.date.to_s)
              )
            end
          end
        end
      end

      private

      # we define here which type of models we can enrich
      def callable_relationships?(artifact)
        artifact.whois_record.nil? || artifact.autonomous_system.nil? || artifact.geolocation.nil? || artifact.certificates.empty?
      end

      # we define here the supported data types supported in input
      def supported_data_types
        %w[domain ip]
      end

      # create a new client instance with API key as argument
      def client
        @client ||= Clients::SilentPush.new(key: Mihari.config.silentpush_api_key)
      end
    end
  end
end
