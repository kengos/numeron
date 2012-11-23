# coding: utf-8

module Numeron
  class Calculator
    # コール履歴
    attr_accessor :histories
    # 解として可能性があるデータリスト
    attr_accessor :possibilities
    # 各桁における解の可能性として考えられる数値
    attr_accessor :mays
    # 解の桁数(未実装)
    attr_accessor :answer_size
    # Slash Number
    attr_accessor :slash_number

    def initialize(answer_size = 3)
      @histories = []
      @possibilities = nil
      @mays = [(0..9).to_a, (0..9).to_a, (0..9).to_a]
      @answer_size = answer_size
      @slash_number = nil
    end

    # コールした数値とその結果を設定
    # @param [String] attack コールした数値
    # @param [Integer] eat Eatの数
    # @param [Integer] bite Biteの数
    # @return [Boolean] 
    def input(attack, eat, bite)
      attack = attack.split(//).map(&:to_i)
      eat = eat.to_i
      bite = bite.to_i

      if attack.size != @answer_size || eat > @answer_size || bite > @answer_size && eat + bite > @answer_size
        raise ArgumentError, 'Invalid argument. '
      end

      @histories << {attack: attack, eat: eat, bite: bite}

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
      elsif eat == 3 && bite == 0
        @possibilities = []
      else
        return false
      end
      return true
    end


    # シャッフル
    def shuffle
      @mays[0] = @mays[0] | @mays[1] | @mays[2]
      @mays[1] = @mays[0] | @mays[1] | @mays[2]
      @mays[2] = @mays[0] | @mays[1] | @mays[2]
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
      @possibilities = list.compact
      @histories.each do |history|
        eat_and_bite = history[:eat] + history[:bite]
        if eat_and_bite == 1
          one_eat_or_one_bite(history[:attack])
        elsif eat_and_bite == 2
          two_eat_or_two_bite(history[:attack])
        end
      end
      calc_slash
    end


    def slash(slash_number)
      @slash_number = slash_number
      calc_slash
    end

    # チェンジ
    # チェンジする桁数の指定とその数値がhigh or lowどちらなのかを宣言する
    # @param [Integer] position チェンジを実行した位置。 0 - 2の範囲
    # @param [Boolean] is_high チェンジしたカードがhighかどうか
    def change(position, is_high)
      raise ArgumentError, 'Invalid argument. position is 0 to 3' if position < 0 && position > 2

      possibilities = is_high ? [5, 6, 7, 8, 9] : [0, 1, 2, 3, 4]
      @mays.each_with_index do |may, i|
        possibilities -= may if may.size == 1
        if i != position
          tmp = may.select {|f| is_high ? f > 4 : f <= 4 }
          next if tmp.size != 1
          @mays[i] -= tmp
        end
      end
      # 3種類に絞りこまれていたら、残りの種類であることが確定
      x = (@mays[0] + @mays[1] + @mays[2]).uniq
      possibilities -= x if x.size == 3
      @mays[position] = possibilities

      # 可能性の再計算
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
      @possibilities = list
    end

  protected
    # 0 Eat 0 Bite の時の可能性計算
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
      update_possibilities(list)
    end

    # 0 Eat 1 Bite の時の可能性計算
    def zero_eat_one_bite(attack)
      # 各桁のeatの可能性がなくなる
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
      update_possibilities(list)
    end

    # 0 Eat 2 Bite の時の可能性計算
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
      update_possibilities(list)
    end

    # 0 Eat 3 Bite の時の可能性計算
    def zero_eat_three_bite(attack)
      # 各桁の可能性が2つに絞られる
      @mays[0] = @mays[0] & [attack[1], attack[2]]
      @mays[1] = @mays[1] & [attack[0], attack[2]]
      @mays[2] = @mays[2] & [attack[0], attack[1]]
      list = [
        validation(attack[1], attack[2], attack[0]),
        validation(attack[2], attack[0], attack[1])
      ].compact
      update_possibilities(list)
    end

    # 1 Eat 0 Bite の時の可能性計算
    def one_eat_zero_bite(attack)
      list = []
      # 先頭eat
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
      update_possibilities(list)
    end

    # 1 Eat 1 Bite の時の可能性計算
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

    # 1 Eat 2 Bite の時の可能性計算
    def one_eat_two_bite(attack)
      # attack以外の可能性がなくなるので、積
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

    # 2 Eat 0 Bite の時の可能性計算
    def two_eat_zero_bite(attack)
      # 先頭2つがeat
      list = []
      (@mays[2] - attack).each do |k|
        list << validation(attack[0], attack[1], k)
      end
      # 先頭、末尾がeat
      (@mays[1] - attack).each do |j|
        list << validation(attack[0], j, attack[2])
      end
      # 真ん中、末尾がeat
      (@mays[0] - attack).each do |i|
        list << validation(i ,attack[1], attack[2])
      end
      update_possibilities(list)
    end

    # 各桁が可能性としてありえるかのチェック
    # @maysに含まれていること、重複がなければ正常と判定する
    # @return [String, nil] 正常な場合はString, 異常値の場合は nil
    def validation(i, j, k)
      return nil if i == j || i == k || j == k
      if @mays[0].include?(i) && @mays[1].include?(j) && @mays[2].include?(k)
        return i.to_s + j.to_s + k.to_s
      else
        return nil
      end
    end

    # シャッフル時の再計算
    # 1 Eat 0 Bite または 0 Eat 1 Biteの場合
    def one_eat_or_one_bite(attack)
      list = []
      # attack[0] - attack[3]が一桁目に含まれている
      (@mays[1] - attack).each do |j|
        (@mays[2] - attack).each do |k|
          next if j == k
          list << validation(attack[0], j, k)
          list << validation(attack[1], j, k)
          list << validation(attack[2], j, k)
        end
      end
      (@mays[0] - attack).each do |i|
        # attack[0..3]が2桁目に含まれている
        (@mays[2] - attack).each do |k|
          next if i == k
          list << validation(i, attack[0], k)
          list << validation(i, attack[1], k)
          list << validation(i, attack[2], k)
        end
        # attack[0..3]が3桁目に含まれている
        (@mays[1] - attack).each do |j|
          next if i == j
          list << validation(i, j, attack[0])
          list << validation(i, j, attack[1])
          list << validation(i, j, attack[2])
        end
      end
      update_possibilities(list)
    end

    # シャッフル時の再計算
    # 2 eat 0 Bite, or 1 Eat 1 Bite or 0 Eat 0 Biteの場合
    def two_eat_or_two_bite(attack)
      list = []
      # 末尾が不明
      (@mays[2] - attack).each do |k|
        list << validation(attack[0], attack[1], k)
        list << validation(attack[0], attack[2], k)
        list << validation(attack[1], attack[0], k)
        list << validation(attack[1], attack[2], k)
        list << validation(attack[2], attack[0], k)
        list << validation(attack[2], attack[1], k)
      end

      # 真ん中が不明
      (@mays[1] - attack).each do |j|
        list << validation(attack[0], j, attack[1])
        list << validation(attack[0], j, attack[2])
        list << validation(attack[1], j, attack[0])
        list << validation(attack[1], j, attack[2])
        list << validation(attack[2], j, attack[0])
        list << validation(attack[2], j, attack[1])
      end

      # 先頭が不明
      (@mays[0] - attack).each do |i|
        list << validation(i, attack[0], attack[1])
        list << validation(i, attack[0], attack[2])
        list << validation(i, attack[1], attack[0])
        list << validation(i, attack[1], attack[2])
        list << validation(i, attack[2], attack[0])
        list << validation(i, attack[2], attack[1])
      end
      update_possibilities(list)
    end

    def calc_slash
      return if @slash_number.nil?
      list = []
      @slash_number.upto(9){|i|
        min = i - slash_number
        from = min + 1
        to = i - 1
        (from..to).to_a.each do |f|
          list << validation(i, min, f)
          list << validation(min, i, f)
          list << validation(i, f, min)
          list << validation(min, f, i)
          list << validation(f, min, i)
          list << validation(f, i, min)
        end
      }
      update_possibilities(list)
    end

    # 可能性リストの更新
    # 現在設定されている可能性リストと引数で渡された可能性リストの論理積をとる
    # @param [Array] possibilities 可能性としてありえる数値リスト
    def update_possibilities(possibilities)
      possibilities.compact!
      @possibilities = @possibilities.nil? ? possibilities : possibilities & @possibilities
    end
  end
end