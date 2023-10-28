# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Slack do
  subject do
    [].tap do |out|
      it = described_class.new(rule: proxy)
      it.artifacts = artifacts
      out << it
    end.first
  end

  include_context "with database fixtures"

  let!(:rule) { Mihari::Models::Rule.first }
  let!(:proxy) { Mihari::Rule.from_model rule }
  let!(:artifacts) do
    [
      Mihari::Models::Artifact.new(data: "1.1.1.1"),
      Mihari::Models::Artifact.new(data: "github.com"),
      Mihari::Models::Artifact.new(data: "http://example.com"),
      Mihari::Models::Artifact.new(data: "44d88612fea8a8f36de82e1278abb02f"),
      Mihari::Models::Artifact.new(data: "example@gmail.com")
    ]
  end

  describe "#attachments" do
    it do
      subject.attachments.each do |a|
        actions = a[:actions] || []
        actions.each do |action|
          expect(action[:url]).to match(/virustotal|urlscan|censys|shodan/)
        end
      end
    end
  end

  describe "#text" do
    let!(:tags) { proxy.tags.join(", ") }

    it do
      expect(subject.text).to include("*Desc.*: #{rule.description}\n*Tags*: #{tags}")
    end
  end

  describe "#configured?" do
    context "with SLACK_WEBHOOK_URL" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return("http://example.com")
      end

      it do
        expect(subject.configured?).to be(true)
      end
    end

    context "without SLACK_WEBHOOK_URL" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return(nil)
      end

      it do
        expect(subject.configured?).to be(false)
      end
    end
  end

  describe "#emit" do
    let!(:mock) { double("notifier") }

    before do
      allow(::Slack::Notifier).to receive(:new).and_return(mock)
      allow(mock).to receive(:post)
    end

    it do
      subject.emit artifacts
      expect(mock).to have_received(:post).once
    end
  end
end
