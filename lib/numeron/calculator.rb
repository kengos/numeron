# coding: utf-8

module Numeron
  class Calculator
    attr_accessor :histories, :possibilities, :mays

    def initialize(card_size = 3)
      @histories = []
      @mays = [(0..9).to_a, (0..9).to_a, (0..9).to_a]
      @possibilities = nil
      @test_mode = false
    end

    def input(attack, eat, bite)
      attack = attack.split(//).map(&:to_i)
      eat = eat.to_i
      bite = bite.to_i
      @histories << [attack, eat, bite]

      if eat == 0 && bite == 0
        zero_eat_zero_bite(attack)
      elsif eat == 0 && bite == 3
        zero_eat_three_bite(attack)
      elsif eat == 0 && bite == 2
        zero_eat_two_bite(attack)
      elsif eat == 0 && bite == 1
        zero_eat_one_bite(attack)
      elsif eat == 1 && bite == 2
        one_eat_two_bite(attack)
      elsif eat == 1 && bite == 1
        one_eat_one_bite(attack)
      elsif eat == 1 && bite == 0
        one_eat_zero_bite(attack)
      elsif eat == 2 && bite == 0
        two_eat_zero_bite(attack)
      elsif eat == 3
        puts "Success"
        return true
      else
        puts "Invalid!"
      end
      return false
    end

    def zero_eat_zero_bite(attack)
      @mays[0] = @mays[0] - attack
      @mays[1] = @mays[1] - attack
      @mays[2] = @mays[2] - attack

      list = []
      @mays[0].each do |i|
        @mays[1].each do |j|
          next if i == j
          @mays[2].each do |k|
            next if i == k || j == k
            list << validation(i, j, k)
          end
        end
      end
      list.compact!
      update_possibilities(list)
    end

    def zero_eat_one_bite(attack)
      @mays[0] = @mays[0] - [attack[0]]
      @mays[1] = @mays[1] - [attack[1]]
      @mays[2] = @mays[2] - [attack[2]]

      list = []
      (@mays[0] - attack).each do |i|
        (@mays[1] - attack).each do |j|
          next if i == j
          list << validation(i, j, attack[0]) if attack[0] != i || attack[0] != j
          list << validation(i, j, attack[1]) if attack[1] != i || attack[1] != j
        end
      end

      (@mays[0] - attack).each do |i|
        (@mays[2] - attack).each do |k|
          next if i == k
          list << validation(i, attack[0], k) if attack[0] != i || attack[0] != j
          list << validation(i, attack[2], k) if attack[1] != i || attack[1] != j
        end
      end

      (@mays[1] - attack).each do |j|
        (@mays[2] - attack).each do |k|
          next if j == k
          list << validation(attack[1], j, k) if attack[1] != j || attack[1] != k
          list << validation(attack[2], j, k) if attack[2] != j || attack[2] != k
        end
      end
      list.compact!
      update_possibilities(list)
    end

    def zero_eat_two_bite(attack)
      @mays[0] = @mays[0] - [attack[0]]
      @mays[1] = @mays[1] - [attack[1]]
      @mays[2] = @mays[2] - [attack[2]]
      list = []

      # 先頭不明
      (@mays[0] - attack).each do |f|
        list << validation(f, attack[0], attack[1])
        list << validation(f, attack[2], attack[0])
        list << validation(f, attack[2], attack[1])
      end

      # 中央不明
      (@mays[1] - attack).each do |f|
        list << validation(attack[1], f, attack[0])
        list << validation(attack[2], f, attack[0])
        list << validation(attack[2], f, attack[1])
      end

      # 末尾不明
      (@mays[2] - attack).each do |f|
        list << validation(attack[1], attack[0], f)
        list << validation(attack[1], attack[2], f)
        list << validation(attack[2], attack[0], f)
      end
      list.compact!
      update_possibilities(list)
    end

    def zero_eat_three_bite(attack)
      @mays[0] = @mays[0] & [attack[1], attack[2]]
      @mays[1] = @mays[1] & [attack[0], attack[2]]
      @mays[2] = @mays[2] & [attack[0], attack[1]]
      list = [
        validation(attack[1], attack[2], attack[0]),
        validation(attack[2], attack[0], attack[1])
      ].compact
      update_possibilities(list)
    end

    def one_eat_zero_bite(attack)
      list = []
      (@mays[1] - attack).each do |j|
        (@mays[2] - attack).each do |k|
          next if j == k
          list << validation(attack[0], j, k)
        end
      end

      # 真ん中eat
      (@mays[0] - attack).each do |i|
        (@mays[2] - attack).each do |k|
          next if i == k
          list << validation(i, attack[1], k)
        end
      end

      # 末尾eat
      (@mays[0] - attack).each do |i|
        (@mays[1] - attack).each do |j|
          next if i == j
          list << validation(i, j, attack[2])
        end
      end
      list.compact!
      update_possibilities(list)
    end

    def one_eat_one_bite(attack)
      list = []
      (@mays[2] - attack).each do |f|
        list << validation(attack[0], attack[2], f)
      end
      (@mays[1] - attack).each do |f|
        list << validation(attack[0], f, attack[1])
      end
      # 2桁目があっている
      (@mays[2] - attack).each do |f|
        list << validation(attack[2], attack[1], f)
      end
      (@mays[0] - attack).each do |f|
        list << validation(f, attack[1], attack[0])
      end
      # 3桁目があっている
      (@mays[0] - attack).each do |f|
        list << validation(f, attack[0], attack[2])
      end
      (@mays[1] - attack).each do |f|
        list << validation(attack[1], f, attack[2])
      end

      update_possibilities(list)
    end

    def one_eat_two_bite(attack)
      # 123 => 021 or 210 or 102
      @mays[0] = @mays[0] & attack
      @mays[1] = @mays[1] & attack
      @mays[2] = @mays[2] & attack
      list = [
        validation(attack[0], attack[2], attack[1]),
        validation(attack[2], attack[1], attack[0]),
        validation(attack[1], attack[0], attack[2])
      ].compact
      update_possibilities(list)
    end

    def two_eat_zero_bite(attack)
      # 012 => 021 or 210 or 102
      # 先頭2つがeat
      list = []
      (@mays[2] - attack).each do |k|
        list << validation(attack[0], attack[1], k)
      end
      (@mays[1] - attack).each do |j|
        list << validation(attack[0], j, attack[2])
      end
      (@mays[0] - attack).each do |i|
        list << validation(i ,attack[1], attack[2])
      end
      list.compact!
      update_possibilities(list)
    end

    def validation(i, j, k)
      return nil if i == j || i == k || j == k
      if @mays[0].include?(i) && @mays[1].include?(j) && @mays[2].include?(k)
        return i.to_s + j.to_s + k.to_s
      else
        return nil
      end
    end

    def update_possibilities(possibilities)
      @possibilities = @possibilities.nil? ? possibilities : possibilities & @possibilities
    end
  end
end