# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive, :vcr do
  subject(:emitter) { described_class.new(rule: rule) }

  include_context "with mocked logger"

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#configured?" do
    before do
      allow(Mihari.config).to receive(:thehive_api_version).and_return("v4")
    end

    it do
      expect(emitter.configured?).to be(true)
    end

    it do
      expect(emitter.normalized_api_version).to be(nil)
    end

    context "with THEHIVE_URL" do
      before do
        allow(Mihari.config).to receive(:thehive_url).and_return(nil)
      end

      it do
        expect(emitter.configured?).to be(false)
      end
    end
  end

  describe "#normalized_api_version" do
    context "with THEHIVE_API_VERSION" do
      before do
        allow(Mihari.config).to receive(:thehive_api_version).and_return("v5")
      end

      it do
        expect(emitter.normalized_api_version).to eq("v1")
      end
    end
  end

  describe "#call" do
    let!(:mock_client) { instance_double("client") }

    before do
      allow(emitter).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:alert)
    end

    it do
      emitter.call artifacts
      expect(mock_client).to have_received(:alert)
    end
  end
end
