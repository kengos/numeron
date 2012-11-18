#!/usr/bin/env ruby
# coding: utf-8

require 'numeron'

simulator = Numeron::Simulator.new
# 結果を標準出力
simulator.verbose = true

# 適当に検証用の答えの一覧を作る()内の数値は作成する答えの数
answers = Numeron::Simulator.build_sample_answers(10)

# 最初の攻撃文字列
first_attack = '123'

result = simulator.run(answers, first_attack) do |calculator|
  # ここにシミュレーションしたいものを記述する(引数はNumeron::Calculator)
  # 下は計算結果において、正解の可能性のリストから1つランダムで選択するパターン
  calculator.possibilities.sample

  # ちなみに10000件回してみたところ上記の可能性があるリストから1つ抜き出す方法の平均手数は 5.213 であった。
end

# シミュレーション結果の集計
sum = 0
result.each do |f|
  sum += f[:times] # 正解までにかかった手数
end

# 平均の手数を出力
puts 'Average: ' + (sum.to_f / result.size.to_f).to_s