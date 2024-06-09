# frozen_string_literal: true

module Mihari
  module Models
    #
    # Certificate Model
    #
    class Certificate < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
