# coding: utf-8

module Numeron
  class Solver
    attr_accessor :calc, :card_size, :used_items
    def initialize
      @calc = Numeron::Calculator.new
      @card_size = 3
      @used_items = {double: false, shuffle: false, change: false, target: false, high_and_low: false, slash: false}
    end

    def run
      while 1
        print "action (item|question|think|finish|help): "
        input = STDIN.gets.chomp.downcase
        if %w(0 i item).include?(input)
          item
        elsif %w(1 q question).include?(input)
          question
        elsif %w(2 t think).include?(input)
          think
        elsif %w(3 f finish).include?(input)
          break
        else
          help
        end
      end
    end

    def help
      puts "----- help messege -----"
      puts "item ... using item, shortcut 0 or i"
      puts "question ... call 3 digits numbers, shortcut 1 or q"
      puts "think ... thinking answer, shortcut 2 or t"
      puts "finish ... exit this console, shortcut 3 or f"
    end

    # アイテムの使用
    def item
      @used_items.each do |f|
        next if f[1] == true
        print "Using " + f[0].to_s + " ? [yes]: "
        input = STDIN.gets.chomp.downcase
        next if input != 'yes' && input != 'y'
        send(f[0])
        @used_items[f[0]] = true
        break
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
      if @calc.possibilities.size <= 10
        @calc.possibilities.each_with_index do |f, i|
          print f
          print i != 0 && i % 5 == 0 ? "\n" : ", "
        end
        print "\n"
      end

      analyzer = Numeron::Analyzer.new(@calc)
      if @calc.possibilities.size > 2
        result = {recommend: 0}
        if @calc.possibilities.size >= 72
          result = analyzer.run_worstcase_mode
        elsif @calc.possibilities.size > 26
          result = analyzer.run_deep_search
        else
          result = analyzer.run_possibilities
        end
        if result[:recommend].size > 0
          puts "Analyzer Answer: " + result[:recommend].sample.to_s
        else
          puts "Calculator Error."
        end
      end
      puts "Possibilitiy list random: " + @calc.possibilities.sample.to_s
    end

    def double
      position = nil
      number = nil

      while 1
        print "Input open number: "
        f = STDIN.gets.chomp.to_i
        if f >= 0 && f <= 9
          number = f
          break
        else
          puts "Input error. Please input 0 to 9 number."
        end
      end

      while 1
        print "Input open position [0, 1, 2]: "
        f = STDIN.gets.chomp.to_i
        if f >= 0 && f <= 2
          position = f
          break
        else
          puts "Input error. Please input 0 or 1 or 2."
        end
      end

      @calc.double(number, position)
    end

    def target
      position = nil
      number = nil

      while 1
        print "Input open number: "
        f = STDIN.gets.chomp.to_i
        if f >= 0 && f <= 9
          number = f
          break
        else
          puts "Input error. Please input 0 to 9 number."
        end
      end

      while 1
        puts "Input open position."
        puts "If the enemy does not open card position, don't put anything"
        print "Input [0, 1, 2, or empty]: "
        f = STDIN.gets.chomp.to_i
        position = f if f >= 0 && f <= 2
        break
      end

      @calc.target(number, position)
    end

    def change
      position = nil
      is_high = nil
      while 1
        print "Input change position: "
        f = STDIN.gets.chomp.to_i
        if f >= 0 && f <= 2
          position = f
          break
        else
          puts "Input error. Please input 0 to 2 number."
        end
      end

      while 1
        print "Input high or low: "
        f = STDIN.gets.chomp.downcase
        if f == 'high' || f == 'low'
          is_high = f == 'high'
          break
        else
          puts "Input error. Please input high or low."
        end
      end

      @calc.change(position, is_high)
    end

    def high_and_low
      result = []
      3.times do |i|
        while 1
          print "position " + i.to_s + " is high? [yes|no]: "
          input = STDIN.gets.chomp.downcase
          if ['yes', 'y', 'no', 'n'].include?(input)
            result[i] = (input == 'yes' || input == 'y')
            break
          else
            puts "Input error. Please input yes or no."
          end
        end
      end
      @calc.high_and_low(result)
    end

    def slash
      while 1
        print "Input slash number: "
        f =STDIN.gets.chomp.to_i
        break if f >= 2 && f <= 9
        puts "Invalid slash number."
      end
      @calc.slash(f)
    end

    def shuffle
      @calc.shuffle
    end
  end
end