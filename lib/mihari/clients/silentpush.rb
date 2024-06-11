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

      # @param type [String]
      # @param data [String]
      # @return [Structs::SilentPush::Response]
      def query(type, data)
        type += "v4" if type == "ip"
        Structs::SilentPush::Response.from_dynamic! get_json("api/v1/merge-api/explore/enrich/#{type}/#{data}?explain=1&scan_data=1")
      end
    end
  end
end
