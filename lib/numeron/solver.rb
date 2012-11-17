# coding: utf-8

module Numeron
  class Solver
    attr_accessor :calc, :card_size
    def initialize
      @calc = Numeron::Calculator.new
      @card_size = 3
    end

    def run
      while 1
        next unless question
        think
        finish
      end
    end

    def question
      attack_number = nil
      eat = 0
      bite = 0
      while 1
        print "Attack number: "
        attack_number = STDIN.gets.chomp
        if @card_size == attack_number.split(//).size
          break
        else
          puts @card_size.to_s + '桁必要です。'
        end
      end

      while 1
        while 1
          print "Eat number: "
          eat = STDIN.gets.chomp.to_i
          if @card_size > eat
            break
          else
            puts @card_size.to_s + "未満の数値を入力してください。"
          end
        end

        while 1
          print "Bite number: "
          bite = STDIN.gets.chomp.to_i
          if @card_size >= bite
            break
          else
            print self.card_size.to_s + "以下の数値を入力してください。"
          end
        end
        if eat + bite <= @card_size
          break
        else
          puts "Eat, Biteの合計が" + @card_size.to_s + "を上回っています。"
        end
      end

      @calc.input(attack_number, eat, bite)
    end

    def think
      puts "残り候補: " + @calc.possibilities.size + "件"
      if @calc.possibilities.size <= 30
        p @calc
      end
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