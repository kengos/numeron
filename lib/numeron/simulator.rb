# coding: utf-8

module Numeron
  class Simulator
    attr_accessor :verbose
    def initialize
      @verbose = false
    end

    def run(answers, first_attack, &block)
      [].tap do |result|
        answers.each {|answer|
          result << {answer: answer, times: calc_answer(answer, first_attack, &block)}
        }
      end
    end

    # 答えが見つかる回数を計算する
    def calc_answer(answer, first_attack, &block)
      calculator = Numeron::Calculator.new
      times = 1
      result = eat_and_bite(answer, first_attack)
      return times if result[:eat] == 3
      calculator.input(first_attack, result[:eat], result[:bite])
      output(times, first_attack, result[:eat], result[:bite], calculator.possibilities.size)

      while times <= 20 # 計算機不具合での無限ループ回避
        times += 1
        input = block.call(calculator)
        result = eat_and_bite(answer, input)
        if result[:eat] == 3
          output(times, input, result[:eat], result[:bite], 0)
          break if result[:eat] == 3
        else
          calculator.input(input, result[:eat], result[:bite])
          output(times, input, result[:eat], result[:bite], calculator.possibilities.size)
        end
      end
      times
    end

    def output(*args)
      if @verbose
        puts args.join(',')
      end
    end

    def eat_and_bite(answer, input)
      inputs = input.split(//).map(&:to_i)
      answers = answer.split(//).map(&:to_i)

      # eatの計算
      { eat: 0, bite: 0 }.tap do |result|
        inputs.each_with_index{|f, i|
          if answers[i] == f
            result[:eat] = result[:eat] + 1
          elsif answers.include?(f)
            result[:bite] = result[:bite] + 1
          end
        }
      end
    end

    def self.build_sample_answers(num = 10)
      lists = []
      (0..9).to_a.each do |i|
        (0..9).to_a.each do |j|
          next if i == j
          (0..9).to_a.each do |k|
            next if i == k || j == k
            lists << i.to_s + j.to_s + k.to_s
          end
        end
      end

      [].tap do |result|
        num.times { result << lists.sample }
      end
    end

    def self.calc_statistics(result)
      sum = 0
      _result = []
      result.each do |f|
        sum += f[:times]
        _result << f[:times]
      end
      _result.sort!

      { max: _result.max, min: _result.min, median: _result[_result.size / 2], average: (sum.to_f / result.size.to_f) }
    end
  end
end