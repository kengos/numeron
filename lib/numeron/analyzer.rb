# coding: utf-8

module Numeron
  class Analyzer
    attr_accessor :calculator
    def initialize(calculator)
      @calculator = calculator
    end

    def run(possibilities = nil, depth = 1)
      recommend = []
      min_size = 10000
      possibilities ||= @calculator.possibilities
      possibilities.each_with_index do |f, i|
        _calculator = build_calculator
        _calculator.input(f, 0, 1)
        if i == 0
          recommend = f
          min_size = _calculator.possibilities.size
        else
          if min_size == _calculator.possibilities.size
            recommend << f
          elsif _calculator.possibilities.size > 0 && min_size > _calculator.possibilities.size
            recommend = [f]
            min_size = _calculator.possibilities.size
          end
        end
      end

      { recommend: recommend, size: min_size }
    end

    def build_calculator
      _calculator = Numeron::Calculator.new
      _calculator.possibilities = @calculator.possibilities.clone
      _calculator.mays = @calculator.mays.clone
      _calculator.histories = @calculator.histories.clone
      return _calculator
    end
  end
end