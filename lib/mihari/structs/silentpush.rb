# frozen_string_literal: true

module Mihari
    module Structs
      module SilentPush
        class DomainInfo < Dry::Struct
          # @!attribute [r] domain
          #   @return [String]
          attribute :domain, Types::String

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
              throw Interrupt
              new(
                domain: d.fetch("domain"),
                zone: d.fetch("zone")
              )
            end
          end
        end

        class Result < Dry::Struct
          # @!attribute [r] domain_info
          #   @return [DomainInfo]
          attribute :domain_info, DomainInfo
  
          class << self
            #
            # @param [Hash] d
            #
            def from_dynamic!(d)
              d = Types::Hash[d]
              new(
                domain_info: DomainInfo.from_dynamic!(d.fetch("domaininfo"))
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
          attribute :error, Types::String
  
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
                code: d.fetch("status_code"),
                error: d.fetch("error"),
                result: Result.from_dynamic!(d.fetch("response"))
              )
            end
          end
        end
      end
    end
  end
  