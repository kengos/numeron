# coding: utf-8

module Numeron
  class Analyzer
    attr_accessor :calculator
    def initialize(calculator)
      @calculator = calculator
    end

    def run(depth = 1, params = {})
      recommend = []
      min_size = 10000
      all_list.each_with_index do |f, i|
        ex = calc_expected_value(f)
        if min_size == ex
          recommend << f
          min_size = ex
        elsif min_size > ex
          recommend = [f]
          min_size = ex
        end
        # _calculator = build_calculator
        # _calculator.input(f, 0, 1)
        # if i == 0
        #   recommend = [f]
        #   min_size = _calculator.possibilities.size
        # else
        #   if min_size == _calculator.possibilities.size
        #     recommend << f
        #   elsif _calculator.possibilities.size > 0 && min_size > _calculator.possibilities.size
        #     recommend = [f]
        #     min_size = _calculator.possibilities.size
        #   end
        # end
      end

      { recommend: recommend, size: min_size }
    end

    # attackの結果、推定される結果に応じた可能性の数に応じた期待値を計算する
    def calc_expected_value(attack)
      result = []
      [
        {eat: 0, bite: 0},
        {eat: 0, bite: 1},
        {eat: 0, bite: 2},
        {eat: 0, bite: 3},
        {eat: 1, bite: 0},
        {eat: 1, bite: 2},
        {eat: 2, bite: 0}
      ].each do |pattern|
        _calculator = build_calculator
        _calculator.input(attack, pattern[:eat], pattern[:bite])
        result << _calculator.possibilities.size
      end

      result.tapp
      n = 0
      sum = 0
      result.each do |f|
        sum = sum + f
        n = n + 1 if f > 0
      end
      sum / n
    end

    def build_calculator
      _calculator = Numeron::Calculator.new
      _calculator.possibilities = @calculator.possibilities.clone
      _calculator.mays = @calculator.mays.clone
      _calculator.histories = @calculator.histories.clone
      return _calculator
    end

    def all_list
      [].tap do |f|
        (0..9).to_a.each { |i|
          (0..9).to_a.each { |j|
            next if i == j
            (0..9).to_a.each { |k|
              next if i == k || j == k
              f << i.to_s + j.to_s + k.to_s
            }
          }
        }
      end
    end

  end
end