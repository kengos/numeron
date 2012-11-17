# coding: utf-8

require 'spec_helper'

describe Numeron::Analyzer do
  let(:analyzer) { Numeron::Analyzer.new(calc) }
  describe '0e1b' do
    let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
    it do
      p analyzer.run
    end
  end
end