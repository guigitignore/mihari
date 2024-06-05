# frozen_string_literal: true

module Mihari
  module Structs
    module SilentPush
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
            Mihari.logger.info(d)

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

      class Result < Dry::Struct
        # @!attribute [r] domain_info
        #   @return [DomainInfo,nil]
        attribute :domain_info, DomainInfo.optional

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              domain_info: DomainInfo.from_dynamic!(d["domaininfo"])
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
