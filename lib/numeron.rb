# coding: utf-8

require "numeron/version"
require 'numeron/calculator'

module Numeron
  class Runner
    attr_accessor :card_size, :store

    def initialize
      self.store = []
      self.card_size = 3
    end

    def run
      # init
      while 1
        question
        think
        finish
      end
    end

    def init
      while 1
        print "Card number: "
        card_size = STDIN.gets.chomp.to_i
        if card_size > 0
          self.card_size = card_size
          break
        else
          print "1以上の整数を入力してください。"
        end
      end
    end

    def question
      attack = {}
      while 1
        print "Attack number: "
        attack_number = STDIN.gets.chomp.split(//)
        if self.card_size == attack_number.size
          attack[:attack] = attack_number
          break
        else
          puts self.card_size.to_s + '桁必要です。'
        end
      end

      while 1
        print "Eat number: "
        eat = STDIN.gets.chomp.to_i
        if self.card_size > eat
          attack[:eat] = eat
          break
        else
          print self.card_size.to_s + "未満の数値を入力してください。"
        end
      end

      while 1
        print "Bite number: "
        bite = STDIN.gets.chomp.to_i
        if self.card_size >= bite
          attack[:bite] = bite
          break
        else
          print self.card_size.to_s + "以下の数値を入力してください。"
        end
      end
      # 可能性の計算
      if attack[eat] == 2
        a = attack[:attack][0]
        b = attack[:attack][1]
        # c = 
      end
      self.store << attack
    end

    def think
      
    end

    def finish
      while 1
        print "finish? [yes|no]"
        f = STDIN.gets.chomp
        if(f == 'yes' || f == 'y')
          exit
        elsif f == 'no' || f == 'n'
          break
        end
      end
    end
  end
end
