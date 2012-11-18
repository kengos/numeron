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
          puts 'Required ' + @card_size.to_s + ' digits.'
        end
      end

      while 1
        while 1
          print "Eat number: "
          eat = STDIN.gets.chomp.to_i
          if @card_size > eat
            break
          else
            puts 'Required less than ' + @card_size.to_s + ' digits.'
          end
        end

        while 1
          print "Bite number: "
          bite = STDIN.gets.chomp.to_i
          if @card_size >= bite
            break
          else
            print 'Required ' + @card_size.to_s + ' digits or less'
          end
        end
        if eat + bite <= @card_size
          break
        else
          puts "Error, Eat + Bite > " + @card_size.to_s
        end
      end

      @calc.input(attack_number, eat, bite)
    end

    def think
      puts "... thinking"
      puts "possibilities: " + @calc.possibilities.size.to_s
      analyzer = Numeron::Analyzer.new(@calc)
      result = @calc.possibilities.size <= 64 ? analyzer.run(:possibilities) : analyzer.run(:average)
      if result[:recommend].size > 0
        puts "Analyzer Answer: " + result[:recommend].sample.to_s
      else
        puts "Calculator Error."
      end
      puts "Possibilitiy list random: " + @calc.possibilities.sample.to_s
    end

    def finish
      while 1
        print "\nfinish? [yes|no] "
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