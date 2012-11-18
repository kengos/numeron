# coding: utf-8

module Numeron
  class Analyzer
    attr_accessor :calculator
    def initialize(calculator)
      @calculator = calculator
    end

    # 次の1手の計算
    # @param [Symbol] mode :average or :worst
    # @return [Hash] {recommend: [Array], size: Number}
    def run(mode = :average, options = {})
      case mode
      when :average
        run_average_mode(options[:cases])
      when :worst
        run_worstcase_mode(options[:worst_case])
      when :possibilities
        run_possibilities
      end
    end

    # 最悪のケースを0e1b, 1e0bと想定し、それぞれの結果が出た際に可能性の平均値が最も少なくなるケースを推定する
    def run_average_mode(cases = nil)
      cases ||= [
        {eat: 0, bite: 1},
        {eat: 1, bite: 0}
      ]
      recommend = []
      min_size = 10000
      all_list.each do |f|
        average = calc_average(f, cases)
        if min_size == average
          recommend << f
        elsif min_size > average
          recommend = [f]
          min_size = average
        end
      end

      { recommend: recommend, size: min_size }
    end

    # 最悪のケースを0e1bと推定し、その結果として最も可能性の数が最も少なくなるケースを推定する
    def run_worstcase_mode(worst_case = {})
      worst_case = {eat: 0, bite: 1}.merge(worst_case)
      min_size = 10000
      recommend = []
      all_list.each do |f|
        _calculator = build_calculator
        _calculator.input(f, worst_case[:eat], worst_case[:bite])
        if min_size == _calculator.possibilities.size
          recommend << f
        elsif min_size > _calculator.possibilities.size
          recommend = [f]
          min_size = _calculator.possibilities.size
        end
      end

      { recommend: recommend, size: min_size }
    end

    def run_possibilities
      possibilities = @calculator.possibilities.clone

      recommend = []
      min_size = 10000
      cases = [
        {eat: 0, bite: 0},
        {eat: 0, bite: 1},
        {eat: 0, bite: 2},
        {eat: 1, bite: 0},
        {eat: 1, bite: 1},
        {eat: 2, bite: 0}
      ]
      possibilities.each do |f|
        average = calc_average(f, cases, true)
        if min_size == average
          recommend << f
        elsif min_size > average
          recommend = [f]
          min_size = average
        end
      end

      { recommend: recommend, size: min_size }
    end

    # attackの結果、推定される結果に対する可能性の数の平均を計算する
    # @example
    #   [10, 20, 10, 0, 5, 0, 5]の場合は ( 10 + 20 + 10 + 5 + 5 ) / 5 = 10
    def calc_average(attack, cases, can_zero = false)
      result = []
      cases.each do |pattern|
        _calculator = build_calculator
        _calculator.input(attack, pattern[:eat], pattern[:bite])
        result << _calculator.possibilities.size
      end

      n = 0
      sum = 0
      result.each do |f|
        sum = sum + f
        n = n + 1 if f > 0
      end

      if n > 0
        return sum.to_f / n.to_f
      elsif can_zero
        return 0
      else
        return 10000
      end
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