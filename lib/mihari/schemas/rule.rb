# frozen_string_literal: true

require "mihari/schemas/analyzer"
require "mihari/schemas/emitter"
require "mihari/schemas/enricher"

module Mihari
  module Schemas
    Rule = Dry::Schema.Params do
      required(:title).value(:string)
      required(:description).value(:string)

      optional(:tags).value(array[:string]).default([])
      optional(:id).value(:string)

      optional(:status).value(:string)

      optional(:related).value(array[:string])
      optional(:references).value(array[:string])

      optional(:author).value(:string)
      optional(:created_on).value(:date)
      optional(:updated_on).value(:date)

      required(:queries).value(:array).each do
        AnalyzerWithoutAPIKey | AnalyzerWithAPIKey | Censys | CIRCL | PassiveTotal | ZoomEye | Urlscan | Crtsh | Feed
      end

      optional(:emitters).value(:array).each { Emitter | MISP | TheHive | Slack | HTTP }

      optional(:enrichers).value(:array).each(Enricher)

      optional(:data_types).value(array[Types::DataTypes]).default(DEFAULT_DATA_TYPES)
      optional(:disallowed_data_values).value(array[:string]).default([])

      optional(:artifact_lifetime).value(:integer)

      before(:key_coercer) do |result|
        # it looks like that dry-schema v1.9.1 has an issue with setting an array of schemas as a default value
        # e.g. optional(:emitters).value(:array).each { Emitter | HTTP }.default(DEFAULT_EMITTERS) does not work well
        # so let's do a dirty hack...
        h = result.to_h

        emitters = h[:emitters]
        h[:emitters] = emitters || DEFAULT_EMITTERS

        enrichers = h[:enrichers]
        h[:enrichers] = enrichers || DEFAULT_ENRICHERS

        h
      end
    end

    class RuleContract < Dry::Validation::Contract
      include Mihari::Mixins::DisallowedDataValue

      params(Rule)

      rule(:disallowed_data_values) do
        value.each do |v|
          key.failure("#{v} is not a valid format.") unless valid_disallowed_data_value?(v)
        end
      end
    end
  end
end
