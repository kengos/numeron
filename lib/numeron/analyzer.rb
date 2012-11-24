# coding: utf-8

module Numeron
  class Analyzer
    attr_accessor :calculator
    def initialize(calculator)
      @calculator = calculator
    end

    def run
      score = all_list.size
      recommend = []
      exclusion_equivalency_list.each do |attack|
        _s = evaluate(attack)
        if score > _s
          score = _s
          recommend = [attack]
        elsif score == _s
          recommend << attack
        end
      end

      { recommend: recommend, score: score }
    end

    def all_list
      @all_list ||= build_all_list
    end

    # 評価関数
    # 想定される結果ごとのその後の可能性数の平均を計算する
    def evaluate(attack)
      @calculator.simulate(attack).tap do |result|
        result.map{|i| i[:possibilities].size }.tap do |possibilities|
          return possibilities.inject(0){|sum, i| sum += i}.to_f / possibilities.size.to_f 
        end
      end
    end

    # 同値な結果を返すデータを排除した一覧を返す
    # @todo わかりにくい
    def exclusion_equivalency_list
      # history中で出現していない数字
      equal_number_1 = (0..9).to_a
      # possibilities中で出現していない数字
      equal_number_2 = equal_number_1.clone
      @calculator.histories.each do |history|
        equal_number_1.reject!{|i| history[:attack].include?(i) }
        break if equal_number_1.size == 0
      end
      @calculator.possibilities.each do |f|
        equal_number_2.reject!{|i| f.split(//).map(&:to_i).include?(i) }
        break if equal_number_2.size == 0
      end
      list = []
      scores = []
      (@calculator.possibilities | all_list).each do |attack|
        next if @calculator.histories.map{|history| history[:attack].join('') }.include?(attack)
        attack = attack.split(//).map(&:to_i)
        # 出現していない数字のヒット数
        hits = [0, 0]
        attack.each do |n|
          hits[0] += 1 if equal_number_1.include?(n)
          hits[1] += 1 if equal_number_2.include?(n)
        end
        if !scores.include?(hits)
          list << attack.join('')
          scores << hits
        end
      end
      list
    end


  protected

    def build_all_list
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