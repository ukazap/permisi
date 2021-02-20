# frozen_string_literal: true

require "spec_helper"

RSpec.describe Permisi::Backend::NullBackend do
  it "has backend interfaces" do
    expect { described_class.findsert_actor(Object.new) }.to raise_error(Permisi::Backend::InvalidBackend)
    expect { described_class.actors }.to raise_error(Permisi::Backend::InvalidBackend)
    expect { described_class.roles }.to raise_error(Permisi::Backend::InvalidBackend)
  end
end
