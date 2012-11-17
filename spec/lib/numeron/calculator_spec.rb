# coding: utf-8

require 'spec_helper'

describe Numeron::Calculator do
  let(:calc) { Numeron::Calculator.new }
  describe '#input' do
    it "0e0b" do
      calc.input('123', 0, 0)
      calc.possibilities.should have(7 * 6 * 5).items
    end

    it "0e1b" do
      calc.input('123', 0, 1)
      calc.possibilities.should have(252).items
    end

    it "0e2b" do
      calc.input('123', 0, 2)
      calc.possibilities.should have(63).items
      calc.input('231', 0, 2)
      calc.possibilities.should have(21).items
    end

    it "0e3b" do
      calc.input('123', 0, 3)
      calc.possibilities.should =~ %w(231 312)
      calc.input('231', 0, 3)
      calc.possibilities.should =~ %w(312)
    end

    it "1e0b" do
      calc.input('123', 1, 0)
      calc.possibilities.should have(126).items
    end

    it "1e1b" do
      calc.input('123', 1, 1)
      calc.possibilities.should have(42).items
    end

    it "1e2b" do
      calc.input('123', 1, 2)
      calc.possibilities.should =~ %w(132 321 213)
    end

    it "2e0b" do
      calc.input('123', 2, 0)
      calc.possibilities.should have(21).items
    end
  end

  describe "#shuffle" do
    it "0e3b" do
      calc.input('123', 0, 3)
      calc.shuffle
      calc.possibilities.should =~ %w(123 132 213 231 312 321)
    end

    it "2e0b" do
      calc.input('123', 2, 0)
      calc.shuffle
      # 12?, 13?, 21?, 23?, 31?, 32? が3パターン, ? = [0, 4, 5, 6, 7, 8, 9]
      # => 6 * 3 * 7=  126
      calc.possibilities.should have(126).items
    end

    it "1e1b" do
      calc.input('123', 1, 1)
      calc.shuffle
      calc.possibilities.should have(126).items
    end

    it "1e0b" do
      calc.input('123', 1, 0)
      calc.shuffle
      calc.possibilities.should have(378).items
    end
  end

  describe "scenario" do
    it "1e0b, 1e2b" do
      calc.input('348', 1, 0)
      calc.input('123', 1, 2)
      calc.possibilities.should == ['321']
    end

    it "3eat is 571" do
      calc.input('123', 0, 1)
      calc.input('245', 0, 1)
      calc.input('367', 0, 1)
      calc.input('890', 0, 0)
      calc.input('416', 0, 1)
      calc.possibilities.should =~ ['571', '751']
    end

    it "0e1b, 0e1b" do
      calc.input('123', 0, 1)
      calc.input('245', 0, 1)
      calc.possibilities.should have(75).items
    end

    it "0e1b, 0e1b 2" do
      calc.input('123', 0, 1)
      calc.input('235', 0, 1)
      calc.possibilities.should have(78).items
    end

    it "0e1b, 0e1b 3" do
      calc.input('123', 0, 1)
      calc.input('145', 0, 1)
      calc.possibilities.should have(90).items
    end

    it "0e1b, 0e1b 4" do
      calc.input('123', 0, 1)
      calc.input('456', 0, 1)
      calc.possibilities.should have(96).items
    end

    it "0e1b, 2e0b" do
      calc.input('123', 0, 1)
      calc.input('245', 2, 0)
      calc.possibilities.tapp #should have(96).items
    end
  end
end