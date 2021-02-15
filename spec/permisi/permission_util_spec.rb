require "spec_helper"

RSpec.describe Permisi::PermissionUtil do
  describe ".allows?" do
    before(:context) do
      @namespace_hash = {
        namespace_a: [:action_a, :action_b],
        namespace_b: [:action_a, :action_b, {
          namespace_b_1: [:action_a, :action_b],
          namespace_b_2: [:action_a, :action_b, {
            namespace_b_2_1: [:action_a, :action_b]
          }]
        }]
      }
      @permission_hash = described_class.transform_namespace(@namespace_hash)
      @permission_hash["namespace_a"]["action_b"] = true
    end

    context "with valid permission hash and action path" do
      it "returns whether or not the action is allowed" do
        allow(Permisi).to receive_message_chain(:config, :default_permissions) {
          described_class.transform_namespace(@namespace_hash)
        }
        expect(described_class.allows?(@permission_hash, "namespace_a.action_b")).to eq true
        expect(described_class.allows?(@permission_hash, "namespace_b.namespace_b_1.action_b")).to eq false
      end
    end

    context "with invalid action path" do
      it "returns false" do
        allow(Permisi).to receive_message_chain(:config, :default_permissions) {
          described_class.transform_namespace(@namespace_hash)
        }
        expect(described_class.allows?(@permission_hash, "namespace_b.asdads.asdsadad.asdad")).to eq false
      end
    end

    context "with invalid permission hash" do
      it "returns false" do
        expect(described_class.allows?([], "namespace_b.asdads.asdsadad.asdad")).to eq false
      end
    end
  end

  describe ".transform_namespace" do
    context "with hash containing valid namespaces" do
      let(:hash) do
        {
          namespace_a: [:action_a, :action_b],
          namespace_b: [:action_a, :action_b, :action_c]
        }
      end

      it "returns a permissions hash" do
        expect(described_class.transform_namespace(hash)).to eq({
          "namespace_a" => {
            "action_a" => false,
            "action_b" => false
          },
          "namespace_b" => {
            "action_a" => false,
            "action_b" => false,
            "action_c" => false
          }
        })
      end
    end

    context "with hash containing nested namespaces" do
      let(:hash) do
        {
          namespace_a: [:action_a, :action_b],
          namespace_b: [:action_a, :action_b, {
            namespace_b_1: [:action_a, :action_b],
            namespace_b_2: [:action_a, :action_b, {
              namespace_b_2_1: [:action_a, :action_b]
            }]
          }]
        }
      end

      it "returns a permissions hash" do
        expect(described_class.transform_namespace(hash)).to eq({
          "namespace_a" => {
            "action_a" => false,
            "action_b" => false
          },
          "namespace_b" => {
            "action_a" => false,
            "action_b" => false,
            "namespace_b_1" => {
              "action_a" => false,
              "action_b" => false
            },
            "namespace_b_2" => {
              "action_a" => false,
              "action_b" => false,
              "namespace_b_2_1" => {
                "action_a" => false,
                "action_b" => false
              }
            }
          }
        })
      end
    end

    context "with hash containing duplicate actions" do
      let(:hash) do
        {
          namespace_a: [
            :action_a,
            :action_a
          ]
        }
      end
      let(:hash_2) do
        {
          namespace_a: [
            :action_a,
            namespace_a_1: [
              :action_a,
              {
                action_a: [:action_a]
              }
            ]
          ]
        }
      end

      it "raises InvalidNamespace" do
        expect { described_class.transform_namespace(hash) }.to raise_error(Permisi::InvalidNamespace, "duplicate entry: `namespace_a.action_a`")
        expect { described_class.transform_namespace(hash_2) }.to raise_error(Permisi::InvalidNamespace, "duplicate entry: `namespace_a.namespace_a_1.action_a`")
      end
    end

    context "with hash containing non-array value" do
      let(:hash) { {namespace_a: 123} }

      it "raises InvalidNamespace" do
        expect { described_class.transform_namespace(hash) }.to raise_error(Permisi::InvalidNamespace, "`namespace_a` should be an array")
      end
    end

    context "with array containing value other than symbol and hash" do
      let(:hash) { {namespace_a: [:action_a, :action_b, []]} }
      let(:hash_2) { {namespace_a: [:action_a, 123]} }
      let(:hash_3) { {namespace_a: [:action_a, :action_b, "action_c"]} }

      it "raises InvalidNamespace" do
        expect { described_class.transform_namespace(hash) }.to raise_error(Permisi::InvalidNamespace, "`namespace_a[2]` should be a symbol or a hash")
        expect { described_class.transform_namespace(hash_2) }.to raise_error(Permisi::InvalidNamespace, "`namespace_a[1]` should be a symbol or a hash")
        expect { described_class.transform_namespace(hash_3) }.to raise_error(Permisi::InvalidNamespace, "`namespace_a[2]` should be a symbol or a hash")
      end
    end
  end

  describe ".sanitize_permissions" do
    context "given a hash" do
      it "sanitizes the hash based on the default permissions" do
        hash = {
          "a" => {
            "a1" => "true",
            "a2" => true,
            "a3" => "wawa",
            "a4" => "false",
            "a5" => false,
            "a6" => nil,
            "a7" => "",
          },
          "b" => {
            "b1" => nil,
            "b2" => true,
            "c" => {
              "c1" => "false",
              "c2" => 1,
              "c3" => false
            }
          }
        }

        allow(Permisi).to receive_message_chain(:config, :default_permissions) do
          {
            "a" => {
              "a1" => false,
              "a2" => false,
              "a3" => false,
              "a4" => false,
              "a5" => false,
              "a6" => false,
              "a7" => false,
            },
            "b" => {
              "b1" => false,
              "b2" => false,
              "c" => {
                "c2" => false
              }
            }
          }
        end

        expect(described_class.sanitize_permissions(hash)).to eq({
          "a" => {
            "a1" => true,
            "a2" => true,
            "a3" => true,
            "a4" => false,
            "a5" => false,
            "a6" => false,
            "a7" => false,
          },
          "b" => {
            "b1" => false,
            "b2" => true,
            "c" => {
              "c2" => true
            }
          }
        })
      end
    end
  end
end
