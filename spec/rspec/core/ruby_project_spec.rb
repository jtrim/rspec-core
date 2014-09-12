require 'spec_helper'

module RSpec
  module Core
    RSpec.describe RubyProject do

      describe "#determine_root" do

        context "with ancestor containing spec directory" do
          it "returns ancestor containing the spec directory" do
            allow(RubyProject).to receive(:ascend_until).and_return('foodir')
            expect(RubyProject.determine_root).to eq("foodir")
          end
        end

        context "without ancestor containing spec directory" do
          it "returns current working directory" do
            allow(RubyProject).to receive(:find_first_parent_containing).and_return(nil)
            expect(RubyProject.determine_root).to eq(".")
          end
        end

      end

      describe "#ascend_until" do
        subject { RubyProject }

        it "works with a normal path" do
          allow(File).to receive(:expand_path).with(".").and_return("/var/ponies")
          expect { |b|
            subject.ascend_until(&b)
          }.to yield_successive_args("/var/ponies", "/var", "/")
        end

        it "works with a path with a trailing slash" do
          allow(File).to receive(:expand_path).with(".").and_return("/var/ponies/")
          expect { |b|
            subject.ascend_until(&b)
          }.to yield_successive_args("/var/ponies", "/var", "/")
        end

        it "works with a path with double slashes" do
          allow(File).to receive(:expand_path).with(".").and_return("/var//ponies/")
          expect { |b|
            subject.ascend_until(&b)
          }.to yield_successive_args("/var/ponies", "/var", "/")
        end

        xit "works with a path with escaped slashes" do
          allow(File).to receive(:expand_path).with(".").and_return("/var\/ponies/")
          expect { |b|
            subject.ascend_until(&b)
          }.to yield_successive_args("/var\/ponies", "/")
        end
      end
    end
  end
end
