# coding: utf-8

module Numeron
  class Simulator
    attr_accessor :answers, :calculator, :debug
    def initialize
      @answers = []
      @calculator = Numeron::Calculator.new
      @debug = false
    end

    def run
      @answers.each do |answer|

      end
    end

    # 答えが見つかる回数を計算する
    def calc_answer(answer)

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
  end
end