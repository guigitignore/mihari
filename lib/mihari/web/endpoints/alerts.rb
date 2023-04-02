# frozen_string_literal: true

module Mihari
  module Endpoints
    class Alerts < Grape::API
      namespace :alerts do
        desc "Search alerts", {
          is_array: true,
          success: Entities::AlertsWithPagination,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Search alerts"
        }
        params do
          optional :page, type: Integer, default: 1
          optional :limit, type: Integer, default: 10

          optional :artifact, type: String
          optional :description, type: String
          optional :rule_id, type: String
          optional :tag, type: String
          optional :title, type: String

          optional :fromAt, type: DateTime
          optional :toAt, type: DateTime

          optional :asn, type: Integer
          optional :dnsRecord, type: String
          optional :reverseDnsName, type: String
        end
        get "/" do
          filter = params.to_h.to_snake_keys

          # normalize keys
          filter["artifact_data"] = filter["artifact"]
          filter["tag_name"] = filter["tag"]
          # symbolize hash keys
          filter = filter.to_h.symbolize_keys

          search_filter_with_pagination = Structs::Filters::Alert::SearchFilterWithPagination.new(**filter)
          alerts = Mihari::Alert.search(search_filter_with_pagination)
          total = Mihari::Alert.count(search_filter_with_pagination.without_pagination)

          present(
            {
              alerts: alerts,
              total: total,
              current_page: filter[:page].to_i,
              page_size: filter[:limit].to_i
            },
            with: Entities::AlertsWithPagination
          )
        end

        desc "Delete an alert", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Delete an alert"
        }
        params do
          requires :id, type: Integer
        end
        delete "/:id" do
          id = params["id"].to_i

          begin
            alert = Mihari::Alert.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          alert.destroy

          status 204
          present({ message: "" }, with: Entities::Message)
        end
      end
    end
  end
end
