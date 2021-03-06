# frozen_string_literal: true

require "spec_helper"

RSpec.describe Permisi::Config do
  describe "#backend=" do
    context "with valid backend name" do
      subject { described_class.new }

      it "loads the backend" do
        subject.backend = :active_record
        expect(subject.backend).to eq Permisi::Backend::ActiveRecord
      end
    end

    context "with invalid backend name" do
      subject { described_class.new }

      it "raises InvalidBackend" do
        expect { subject.backend = :mongoid }.to raise_error Permisi::Backend::InvalidBackend
      end
    end
  end

  describe "#backend" do
    context "without backend" do
      subject { described_class.new }

      it "returns NullBackend" do
        expect(subject.backend).to eq Permisi::Backend::NullBackend
      end
    end

    context "with valid backend" do
      subject { described_class.new }

      it "returns the backend" do
        allow(subject).to receive(:backend) { DummyBackend }
        expect(subject.backend).to eq DummyBackend
      end
    end
  end

  describe "#permissions=" do
    context "with valid permission namespace hash" do
      subject { described_class.new }

      it "assigns successfully and generates the default permissions hash" do
        expect { subject.permissions = { a: %i[b c] } }.not_to raise_error
        expect(subject.permissions).to eq HashWithIndifferentAccess.new({ a: %i[b c] })
        expect(subject.default_permissions).to eq HashWithIndifferentAccess.new({ a: { b: false, c: false } })
      end
    end

    context "with invalid permission namespace hash" do
      subject { described_class.new }

      it "raises InvalidNamespace" do
        expect do
          subject.permissions = { a: %i[b c], c: 123 }
        end.to raise_error Permisi::PermissionUtil::InvalidNamespace
        expect(subject.permissions).to eq({})
        expect(subject.default_permissions).to eq({})
      end
    end
  end

  describe "#cache_store" do
    subject { described_class.new }

    it "responds to #fetch" do
      expect(subject.cache_store.respond_to? :fetch).to be true
    end
  end

  describe "#cache_store=" do
    subject { described_class.new }

    context "given a valid cache store" do
      it "uses the cache store" do
        DummyCacheStore = Class.new do
          def fetch(cache_key)
            yield if block_given?
          end
        end

        expect { subject.cache_store = DummyCacheStore.new }.not_to raise_error
        expect(subject.cache_store.class).to be DummyCacheStore
      end
    end

    context "given an invalid cache store" do
      it "raises InvalidCacheStore" do
        expect { subject.cache_store = Object.new }.to raise_error(Permisi::Config::InvalidCacheStore)
      end
    end
  end
end
