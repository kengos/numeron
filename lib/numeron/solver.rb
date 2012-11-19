# coding: utf-8

module Numeron
  class Solver
    attr_accessor :calc, :card_size, :used_items
    def initialize
      @calc = Numeron::Calculator.new
      @card_size = 3
      @used_items = {slash: false, shuffle: false}
    end

    def run
      while 1
        item
        next unless question
        think
        finish
      end
    end

    # アイテムの使用
    def item
      shuffle unless @used_items[:shuffle]
      slash unless @used_items[:slash]
    end

    def slash
      print "\nUsing slash? [yes]"
      f = STDIN.gets.chomp
      return if f != 'yes' && f != 'y'
      while 1
        print "Input slash number: "
        f =STDIN.gets.chomp.to_i
        break if f >= 2 && f <= 9
        puts "Invalid slash number."
      end
      @calc.slash(f)
      @used_items[:slash] = true
      think
    end

    def shuffle
      print "\nUsing shuffle? [yes]"
      f = STDIN.gets.chomp
      return if f != 'yes' && f != 'y'
      @calc.shuffle
      @used_items[:shuffle] = true
      think
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
      if @calc.possibilities.size > 2
        result = {recommend: 0}
        if @calc.possibilities.size > 64
          result = analyzer.run_average_mode
        elsif @calc.possibilities.size > 21
          result = analyzer.run_possibilities
        else
          cases = [
            {eat: 0, bite: 0},
            {eat: 0, bite: 1},
            {eat: 0, bite: 2},
            {eat: 1, bite: 0},
            {eat: 1, bite: 1},
            {eat: 2, bite: 0}
          ]
          result = analyzer.run_average_mode(cases)
        end
        if result[:recommend].size > 0
          puts "Analyzer Answer: " + result[:recommend].sample.to_s
        else
          puts "Calculator Error."
        end
      end
      puts "Possibilitiy list random: " + @calc.possibilities.sample.to_s
    end

    def finish
      while 1
        print "\nfinish? [yes] "
        f = STDIN.gets.chomp
        if(f == 'yes' || f == 'y')
          exit
        else
          break
        end
      end
    end
  end
end