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
        unless scan_data.certificates.empty?
          artifact.certificates = scan_data.certificates.map do |certificate|
            domains = []
            domains << certificate.domain unless certificate.domain.empty?
            domains += certificate.domains
            domains << certificate.hostname unless certificate.hostname.nil?

            Models::Certificate.new(
              domains: domains.uniq.join(","),
              fingerprint_sha1: certificate.fingerprint_sha1,
              is_expired: certificate.is_expired,
              issuer_common_name: certificate.issuer_common_name,
              issuer_organization: certificate.issuer_organization,
              not_after: DateTime.parse(certificate.not_after),
              not_before: DateTime.parse(certificate.not_before),
              created_at: DateTime.parse(certificate.scan_date)
            )
          end
          Mihari.logger.info("artifact certificates #{artifact.certificates.inspect}")
        end
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      def call(artifact)
        Mihari.logger.info("artifact : #{artifact.inspect}")

        res = case artifact.data_type
        when "domain" then client.query_domain(artifact.data)
        when "ip" then client.query_ipv4(artifact.data)
        end

        Mihari.logger.info("res : #{res.inspect}")

        res.result.domain_info&.tap do |domain_info|
          unless domain_info.registrar.empty? || domain_info.whois_created_date.empty?
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

        res.result.scan_data&.tap { |x| parse_scan_data(artifact, x) }

        res.result.ip2asn.map do |ip2asn|
          artifact.autonomous_system ||= Models::AutonomousSystem.new(number: ip2asn.asn)
          parse_scan_data(artifact, ip2asn.scan_data)

          unless ip2asn.ip_location.nil?
            artifact.geolocation ||= Models::Geolocation.new(
              country: ip2asn.ip_location.country_name,
              country_code: ip2asn.ip_location.country_code,
              created_at: DateTime.parse(ip2asn.date.to_s)
            )
          end
        end

        artifact
      end

      private

      def callable_relationships?(artifact)
        artifact.whois_record.nil? || artifact.autonomous_system.nil? || artifact.geolocation.nil? || artifact.certificates.nil?
      end

      def supported_data_types
        %w[domain ip]
      end

      def client
        @client ||= Clients::SilentPush.new(key: Mihari.config.silentpush_api_key)
      end
    end
  end
end
