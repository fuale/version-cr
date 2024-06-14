require "./spec_helper"

alias SemVer = Version::SemVer

describe SemVer do
  describe "#<=>" do
    it "works" do
      (SemVer.new(1, 0, 0) <=> SemVer.new(0, 0, 0)).should eq 1
    end
  end
end
