# coding: utf-8

require 'spec_helper'

describe Numeron::Analyzer do
  let(:analyzer) { Numeron::Analyzer.new(calc) }

  describe '#exclusion_equivalency_list' do
    context "histories size is 1" do
      let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
      it { analyzer.exclusion_equivalency_list =~ ["041", "012", "045", "132"] }
    end
    context "histories size is 2" do
      let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 3)} }
      it { analyzer.exclusion_equivalency_list =~ ["231", "012", "014", "045"] }
    end
  end

  describe '#run' do
    let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
    it do
      result = analyzer.run
      result[:recommend].should have(1).items
      result[:score].should == 31.375
    end
  end
end