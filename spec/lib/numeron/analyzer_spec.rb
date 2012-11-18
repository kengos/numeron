# coding: utf-8

require 'spec_helper'

describe Numeron::Analyzer do
  let(:analyzer) { Numeron::Analyzer.new(calc) }
  describe '#run_average_mode' do
    context '0e1b' do
      let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
      it do
        result = analyzer.run_average_mode
        result[:recommend].should have(378).items
        result[:size].should == 60.0
      end
    end
  end

  describe '#run_worstcase_mode' do
    let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
    it do
      result = analyzer.run_worstcase_mode
      result[:recommend].should have(21).items
      result[:size].should == 72
    end
  end

  describe '#run_possibilities' do
    let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 3) } }
    it do
      result = analyzer.run_possibilities
      result[:recommend].should =~ %w(312 231)
      result[:size].should == 0
    end
  end
end