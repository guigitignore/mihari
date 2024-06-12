# frozen_string_literal: true

module Mihari
  module Entities
    class Certificate < Grape::Entity
      expose :domains, documentation: {type: String, required: true}
      expose :fingerprint_sha1, documentation: {type: String, required: true}
      expose :ip, documentation: {type: String, required: false}
      expose :is_expired, documentation: {type: Grape::API::Boolean, required: true}
      expose :issuer_common_name, documentation: {type: String, required: true}
      expose :issuer_organization, documentation: {type: String, required: true}
      expose :not_after, documentation: {type: DateTime, required: false}
      expose :not_before, documentation: {type: DateTime, required: false}
      expose :created_at, documentation: {type: DateTime, required: true}, as: :createdAt
    end
  end
end
