# frozen_string_literal: true

module Mihari
  module Structs
    module Rule
      class SearchFilter < Dry::Struct
        attribute? :description, Types::String.optional
        attribute? :tag_name, Types::String.optional
        attribute? :title, Types::String.optional
        attribute? :from_at, Types::DateTime.optional
        attribute? :to_at, Types::DateTime.optional
      end

      class SearchFilterWithPagination < SearchFilter
        attribute? :page, Types::Int.default(1)
        attribute? :limit, Types::Int.default(10)

        def without_pagination
          SearchFilter.new(
            description: description,
            from_at: from_at,
            tag_name: tag_name,
            title: title,
            to_at: to_at
          )
        end
      end

      class Rule
        attr_reader :data, :errors

        def initialize(data)
          @data = data.deep_symbolize_keys
          @errors = nil
          @no_method_error = nil

          validate
        end

        #
        # @return [Boolean]
        #
        def errors?
          return false if @errors.nil?

          !@errors.empty?
        end

        #
        # @return [Array<String>]
        #
        def error_messages
          return [] if @errors.nil?

          @errors.messages.map do |message|
            path = message.path.map(&:to_s).join
            "#{path} #{message.text}"
          end
        end

        def validate
          begin
            contract = Schemas::RuleContract.new
            result = contract.call(data)
          rescue NoMethodError => e
            @no_method_error = e
            return
          end

          @data = result.to_h
          @errors = result.errors
        end

        def validate!
          raise RuleValidationError, "Data should be a hash" unless data.is_a?(Hash)

          raise RuleValidationError, error_messages.join("\n") if errors?

          raise RuleValidationError, "Something wrong with queries" unless @no_method_error.nil?
        end

        def [](key)
          data[key.to_sym]
        end

        #
        # @return [String]
        #
        def id
          @id ||= data[:id] || UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, data.to_yaml).to_s
        end

        #
        # @return [String]
        #
        def title
          @title ||= data[:title]
        end

        #
        # @return [String]
        #
        def description
          @description ||= data[:description]
        end

        #
        # @return [Mihari::Rule]
        #
        def to_model
          Mihari::Rule.new(
            id: id,
            title: title,
            description: description,
            data: data
          )
        end
      end
    end
  end
end
