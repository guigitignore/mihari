# frozen_string_literal: true

class RuleCLI < Mihari::CLI::Base
  include Mihari::Commands::Rule
end

RSpec.describe Mihari::Commands::Rule do
  let_it_be(:rule) { FactoryBot.create(:rule) }

  describe "#rule" do
    let!(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after { FileUtils.rm path, force: true }

    it do
      expect { RuleCLI.start ["init", path] }.to output(include("A new rule file has been initialized")).to_stdout
    end
  end

  describe "#validate" do
    let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }
    let!(:data) { File.read path }
    let!(:rule_id) { YAML.safe_load(data)["id"] }

    it do
      expect { RuleCLI.start ["validate", path] }.to output(include(rule_id)).to_stdout
    end

    context "with invalid rule" do
      let!(:path) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }

      it do
        # TODO: assert UnwrapError
        expect { RuleCLI.start ["validate", path] }.to raise_error(Dry::Monads::UnwrapError)
      end
    end
  end

  describe "#list" do
    it do
      expect { RuleCLI.start ["list"] }.to output(include(rule.id)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { RuleCLI.start ["get", rule.id] }.to output(include(rule.id)).to_stdout
    end
  end
end
