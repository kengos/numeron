# coding: utf-8

require 'spec_helper'

describe Numeron::Analyzer do
  let(:analyzer) { Numeron::Analyzer.new(calc) }
  describe '0e1b' do
    let(:calc) { Numeron::Calculator.new.tap{|f| f.input('123', 0, 1) } }
    it do
      result = analyzer.run
      result[:size].tapp
      result[:recommend].first.tapp
    end
    # it do
    #   result = analyzer.calc_expected_value('567')
    #   p result
    # end
    # it do
    #   result = analyzer.calc_expected_value('210')
    #   p result
    # end
    # it do
    # end
  end
end