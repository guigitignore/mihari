# frozen_string_literal: true

module Mihari
  module Models
    #
    # Certificate Model
    #
    # SilentPush enricher provide certificates so we add it as a new model
    class Certificate < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
