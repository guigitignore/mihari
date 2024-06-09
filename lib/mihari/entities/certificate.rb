# frozen_string_literal: true

module Mihari
  module Entities
    class Certificate < Grape::Entity
      expose :domain, documentation: {type: String, required: true}
      expose :fingerprint_sha1, documentation: {type: String, required: true}
      expose :created_at, documentation: {type: DateTime, required: true}, as: :createdAt
    end
  end
end
