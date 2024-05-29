module Mihari
    module Clients
        #
        # SilentPush API client
        #
        class SilentPush < Base
            def initialize(
                base_url = "https://api.silentpush.com/api/v1/merge-api",
                key:
                headers: {},
                pagination_interval: Mihari.config.pagination_interval,
                timeout: nil
            )
                

                raise(ArgumentError, "API key is required") if key.nil?
                headers["X-API-KEY"] = key
                super(base_url, headers:, pagination_interval:, timeout:)
            end


        end
    end
end
        