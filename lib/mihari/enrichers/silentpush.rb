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
          Mihari.logger.info(res)
          artifact.tap do |tapped|
            
          end
        end
  
        private
        def callable_relationships?(artifact)
          artifact.created_at.nil?
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