#!/usr/bin/env ruby
# coding: utf-8

require 'numeron'

simulator = Numeron::Simulator.new
# 結果を標準出力
simulator.verbose = true

# 適当に検証用の答えの一覧を作る()内の数値は作成する答えの数
answers = Numeron::Simulator.build_sample_answers(100)

# 最初の攻撃文字列
first_attack = '123'

result = simulator.run(answers, first_attack) do |calculator|
  ## ここにシミュレーションしたいものを記述する(引数はNumeron::Calculator)
  ## 下は計算結果において、正解の可能性のリストから1つランダムで選択するパターン
  ## ちなみに10000件回してみたところ上記の可能性があるリストから1つ抜き出す方法の平均手数は 5.213 であった。
  # calculator.possibilities.sample

  ## Analyzerを使うパターン
  ## max: 8, min: 2, median: 6, average: 5.74 (n=100)
  # if calculator.possibilities.size > 21
  #   analyzer = Numeron::Analyzer.new(calculator)
  #   recommend = analyzer.run_worstcase_mode[:recommend]
  #   if recommend.size > 0
  #     recommend.sample
  #   else
  #     calculator.possibilities.sample
  #   end
  # else
  #   calculator.possibilities.sample
  # end

  ## max: 8, min: 3, median: 6, average: 5.9
  analyzer = Numeron::Analyzer.new(calculator)
  if calculator.possibilities.size > 21
    recommend = analyzer.run_worstcase_mode[:recommend]
    if recommend.size > 0
      recommend.sample
    else
      calculator.possibilities.sample
    end
  else
    recommend = analyzer.run_possibilities[:recommend]
    if recommend.size > 0
      recommend.sample
    else
      calculator.possibilities.sample
    end
  end

end

Numeron::Simulator.calc_statistics(result).each do |k, v|
  puts k.to_s + ': ' + v.to_s
end