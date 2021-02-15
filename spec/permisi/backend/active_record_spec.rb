require "spec_helper"

RSpec.describe Permisi::Backend::ActiveRecord do
  it "implements backend interfaces" do
    expect(described_class.respond_to?(:findsert_actor)).to be true
    expect(described_class.respond_to?(:actors)).to be true
    expect(described_class.respond_to?(:roles)).to be true
  end

  describe Permisi::Backend::ActiveRecord::Actor do
    subject { described_class.new }

    it "implements actor interfaces" do
      expect(subject.respond_to?(:has_role?)).to be true
      expect(subject.respond_to?(:may?)).to be true
    end
  end

  describe Permisi::Backend::ActiveRecord::Role do
    subject { described_class.new }

    it "implements role interfaces" do
      expect(subject.respond_to?(:allows?)).to be true
    end
  end
end
