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
  end
end