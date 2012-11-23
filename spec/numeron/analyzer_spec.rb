# coding: utf-8

require 'spec_helper'

describe Numeron::Analyzer do
  let(:analyzer) { Numeron::Analyzer.new(calc) }

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

  describe 'simulation: possibilities is 45' do
    let(:calc) {
      Numeron::Calculator.new.tap{|f|
        f.input('123', 0, 1) # 287
        f.input('245', 1, 0)
      }
    }
    it { calc.possibilities.should have(45).items }
    it 'run_worstcase_mode' do
      result = analyzer.run_worstcase_mode
      result[:recommend].should =~ %w(205 265 275 285 295)
      result[:size].should == 2
    end

    it 'run_possibilities' do
      result = analyzer.run_possibilities
      result[:recommend].should =~ %w(035 635 735 835 935)
      result[:size].should == 6.2
    end
  end

  describe 'simulation: possibilities is 26' do
    let(:calc) {
      Numeron::Calculator.new.tap{|f|
        f.input('123', 0, 1) # 702
        f.input('245', 0, 1)
        f.input('367', 0, 1)
      }
    }
    it { calc.possibilities.should have(26).items }
    it 'run_worstcase_mode' do
      result = analyzer.run_worstcase_mode
      result[:recommend].should =~ %w(431 512 631 712) # 9 15 6 4 => 8.5
      result[:size].should == 1
    end

    it 'run_possibilities' do
      result = analyzer.run_possibilities
      result[:recommend].should =~ %w(416 751) # 9, 3 => 6
      result[:size].should == 3.2
    end
  end

  describe 'simulation: possibilities is 7' do
    let(:calc) {
      Numeron::Calculator.new.tap{|f|
        f.input('123', 0, 1) # 287
        f.input('245', 1, 0)
        f.input('467', 1, 0)
      }
    }

    it { calc.possibilities.should have(7).items }
    it 'run_worstcase_mode' do
      result = analyzer.run_worstcase_mode
      result[:recommend].should have(122).items
      result[:size].should == 1
    end

    it 'run_possibilities' do
      result = analyzer.run_possibilities
      result[:recommend].should =~ %w(207 287 297)
      result[:size].should == 1.5
    end
  end
end