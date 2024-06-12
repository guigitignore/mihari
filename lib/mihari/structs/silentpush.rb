# frozen_string_literal: true

module Mihari
  module Structs
    module SilentPush
      class Certificate < Dry::Struct
        # @!attribute [r] domain
        #   @return [String]
        attribute :domain, Types::String

        # @!attribute [r] domains
        #   @return [Array<String>]
        attribute :domains, Types.Array(Types::String)

        # @!attribute [r] fingerprint_sha1
        #   @return [String]
        attribute :fingerprint_sha1, Types::String

        # @!attribute [r] ip
        #   @return [String,nil]
        attribute? :ip, Types::String.optional

        # @!attribute [r] hostname
        #   @return [String,nil]
        attribute? :hostname, Types::String.optional

        # @!attribute [r] is_expired
        #   @return [Boolean]
        attribute :is_expired, Types::Bool

        # @!attribute [r] issuer_common_name
        #   @return [String]
        attribute :issuer_common_name, Types::String

        # @!attribute [r] issuer_organization
        #   @return [String]
        attribute :issuer_organization, Types::String

        # @!attribute [r] not_after
        #   @return [String]
        attribute :not_after, Types::String

        # @!attribute [r] not_before
        #   @return [String]
        attribute :not_before, Types::String

        # @!attribute [r] scan_date
        #   @return [String]
        attribute :scan_date, Types::String

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            new(
              domain: d.fetch("domain"),
              domains: d.fetch("domains"),
              fingerprint_sha1: d.fetch("fingerprint_sha1"),
              ip: d["ip"],
              hostname: d["hostname"],
              is_expired: d.fetch("is_expired"),
              issuer_common_name: d.fetch("issuer_common_name"),
              issuer_organization: d.fetch("issuer_organization"),
              not_after: d.fetch("not_after"),
              not_before: d.fetch("not_before"),
              scan_date: d.fetch("scan_date")
            )
          end
        end
      end

      class DomainInfo < Dry::Struct
        # @!attribute [r] age
        #   @return [Integer,nil]
        attribute? :age, Types::Int.optional

        # @!attribute [r] age_score
        #   @return [Integer,nil]
        attribute? :age_score, Types::Int.optional

        # @!attribute [r] domain
        #   @return [String]
        attribute :domain, Types::String

        # @!attribute [r] first_seen
        #   @return [Integer,nil]
        attribute? :first_seen, Types::Int.optional

        # @!attribute [r] is_new
        #   @return [Boolean,nil]
        attribute? :is_new, Types::Bool.optional

        # @!attribute [r] is_new_score
        #   @return [Integer,nil]
        attribute? :is_new_score, Types::Int.optional

        # @!attribute [r] last_seen
        #   @return [Integer,nil]
        attribute? :last_seen, Types::Int.optional

        # @!attribute [r] query
        #   @return [String]
        attribute :query, Types::String

        # @!attribute [r] registrar
        #   @return [String]
        attribute :registrar, Types::String

        # @!attribute [r] whois_created_date
        #   @return [String]
        attribute :whois_created_date, Types::String

        # @!attribute [r] zone
        #   @return [String]
        attribute :zone, Types::String

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            new(
              age: d["age"],
              age_score: d["age_score"],
              domain: d.fetch("domain"),
              first_seen: d["first_seen"],
              is_new: d["is_new"],
              is_new_score: d["is_new_score"],
              last_seen: d["last_seen"],
              query: d.fetch("query"),
              registrar: d.fetch("registrar"),
              whois_created_date: d.fetch("whois_created_date"),
              zone: d.fetch("zone")
            )
          end
        end
      end

      class IpLocation < Dry::Struct
        # @!attribute [r] continent_code
        #   @return [String]
        attribute :continent_code, Types::String

        # @!attribute [r] country_code
        #   @return [String]
        attribute :country_code, Types::String

        # @!attribute [r] country_is_in_european_union
        #   @return [Boolean]
        attribute :country_is_in_european_union, Types::Bool

        # @!attribute [r] country_name
        #   @return [String]
        attribute :country_name, Types::String

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            return nil if d.key?("no_data")

            new(
              continent_code: d.fetch("continent_code"),
              country_code: d.fetch("country_code"),
              country_is_in_european_union: d.fetch("country_is_in_european_union"),
              country_name: d.fetch("country_name")
            )
          end
        end
      end

      class ScanData < Dry::Struct
        # @!attribute [r] certificates
        #   @return [Array<Mihari::Structs::SilentPush::Certificate>]
        attribute :certificates, Types.Array(Certificate)

        class << self
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            new(
              certificates: d.fetch("certificates").map { |x| Certificate.from_dynamic!(x) }
            )
          end
        end
      end

      class ASN < Dry::Struct
        # @!attribute [r] asn
        #   @return [Integer]
        attribute :asn, Types::Int

        # @!attribute [r] asn_allocation_age
        #   @return [Integer]
        attribute :asn_allocation_age, Types::Int

        # @!attribute [r] asn_allocation_date
        #   @return [Integer]
        attribute :asn_allocation_date, Types::Int

        # @!attribute [r] asn_allocation_date
        #   @return [String]
        attribute :asname, Types::String

        # @!attribute [r] ip_location
        #   @return [IpLocation,nil]
        attribute? :ip_location, IpLocation.optional

        # @!attribute [r] date
        #   @return [Integer]
        attribute :date, Types::Int

        # @!attribute [r] scan_data
        #   @return [Mihari::Structs::SilentPush::ScanData]
        attribute :scan_data, ScanData

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              asn: d.fetch("asn"),
              asn_allocation_age: d.fetch("asn_allocation_age"),
              asn_allocation_date: d.fetch("asn_allocation_date"),
              asname: d.fetch("asname"),
              ip_location: IpLocation.from_dynamic!(d.fetch("ip_location")),
              date: d.fetch("date"),
              scan_data: ScanData.from_dynamic!(d.fetch("scan_data"))
            )
          end
        end
      end

      class Result < Dry::Struct
        # @!attribute [r] domain_info
        #   @return [DomainInfo,nil]
        attribute? :domain_info, DomainInfo.optional

        # @!attribute [r] ip2asn
        #   @return [Array<Mihari::Structs::SilentPush::ASN>]
        attribute :ip2asn, Types.Array(ASN)

        # @!attribute [r] scan_data
        #   @return [Mihari::Structs::SilentPush::ScanData,nil]
        attribute? :scan_data, ScanData.optional

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              domain_info: d["domaininfo"]&.yield_self { |x| DomainInfo.from_dynamic!(x) },
              ip2asn: d.fetch("ip2asn", []).map { |x| ASN.from_dynamic!(x) },
              scan_data: d["scan_data"]&.yield_self { |x| ScanData.from_dynamic!(x) }
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] code
        #   @return [Integer]
        attribute :status_code, Types::Int

        # @!attribute [r] status
        #   @return [String,nil]
        attribute :error, Types::String.optional

        # @!attribute [r] result
        #   @return [Result]
        attribute :result, Result

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            new(
              status_code: d.fetch("status_code"),
              error: d.fetch("error"),
              result: Result.from_dynamic!(d.fetch("response"))
            )
          end
        end
      end
    end
  end
end
