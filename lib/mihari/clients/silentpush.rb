module Mihari
    module Clients
        #
        # SilentPush API client
        #
        class SilentPush < Base
            def initialize(
                base_url = "https://api.silentpush.com",
                key:,
                headers: {},
                pagination_interval: Mihari.config.pagination_interval,
                timeout: nil
            )
                

                raise(ArgumentError, "API key is required") if key.nil?
                headers["X-API-KEY"] = key
                super(base_url, headers:, pagination_interval:, timeout:)
            end

            def query(domain)
                Structs::SilentPush::Response.from_dynamic! get_json("api/v1/merge-api/explore/enrich/domain/#{domain}")
            end


        end
    end
end
        