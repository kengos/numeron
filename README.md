# Numeron

ヌメロンの解の探索プログラム (Ruby版, 3桁Only)

1. 解として可能性のある数値を自動計算
2. ダブル(されたあとの開放されたカード番号指定), ターゲット, チェンジ, ハイアンドロー, スラッシュ, シャッフルに対応
3. 次に出すべき1手を計算してくれるAnalyzer
4. シミュレーター付き(要実装)

## インストール

ruby 1.9以上が必要です

    $ gem install numeron

## Solverの使い方

irbで実行します

```ruby
> require 'numeron'
true
> Numeron::Solver.new.run
action (item|question|think|finish|help): 
```

### actionの説明

```
item ... アイテムを使う、使われた場合はこれを入力。0 または i をいれてもアイテム利用コンソールが起動する
question ... 相手に対して、3桁の数値をコールする。
think ... 答えを計算します。
finish ... 終了
```

### itemの説明

ダブルから順番に使用するアイテムを聞かれますので、使用する箇所でyes or yを入力します。

```
Using double ? [yes]: 
Using shuffle ? [yes]: 
Using change ? [yes]: 
Using target ? [yes]: 
Using high_and_low ? [yes]: 
Using slash ? [yes]:
```

#### double

```
Input open number: # <= 相手が開けた数値を入力します。(0 から 9)
Input open position [0, 1, 2]: # <= 開けた数値の位置を入力します。(0が一番左側)
```

#### shuffle

特に入力は求められません

#### change

```
Input change position: # <= 相手がチェンジした位置を入力します。(0が一番左側)
Input high or low: # <= チェンジした数値がhigh なのか low なのかを入力します
```

#### target

```
Input open number: # <= ターゲットで指定した番号を入力します。(0から9)
Input open position.
If the enemy does not open card position, don't put anything
Input [0, 1, 2, or empty]: # <= その番号が存在した場合はその位置を入力します(0が一番左側), 存在しなかった場合は何も入力しません。
```

#### high_and_low

```
position 0 is high? [yes|no]: # <= 左側がhighの場合は yes or y, lowの場合はno or nを入力
position 1 is high? [yes|no]: # <= 真ん中がhighの場合は yes or y, lowの場合はno or nを入力
position 2 is high? [yes|no]: # <= 右側がhighの場合は yes or y, lowの場合はno or nを入力
```

#### slash

```
Input slash number: # <= slashナンバーを入力
```

### questionの説明

コールした数値とその解答を入力するメイン部分です。

```
Attack number: 123 # <= callした数値を入力
Eat number: 0 # <= callした結果 eatの数を入力
Bite number: 0 # <= callした結果 biteの数を入力
```

### thinkの説明

PCが計算した答えを表示してくれます。
結構適当です。

```
... thinking
possibilities: 48 # <= 答えの可能性として考えられる個数
Analyzer Answer: 789 # <= アナライザーが出した答え
Possibilitiy list random: 345 # <= 答えの候補からランダムで取り出した数値
```

## Simulatorの使い方

コンピューターが何手で解にたどり着くかのシミュレーションをすることができます。

```ruby
require 'numeron'

simulator = Numeron::Simulator.new
# 最初にコールする番号
first_attack = '123'
# シミュレーションする答えのリスト
answers = ['403', '256']

result = simulator.run(answers, first_attack) do |calculator|
  # ここにシミュレーションしたいコードを書く
  # calculatorはNumeron::Calculatorオブジェクト
end

p result
```

詳細は https://github.com/kengos/numeron/blob/master/examples/simulator_example.rb を参照

## Numeron::Calculator

ヌメロンの解の可能性として考えられるものを計算する部分。


基本

```ruby
calc = Numeron::Calculator.new
calc.input('123', 0, 1) # callした番号, Eatの数, Biteの数
p calc.possibilities # 答えの可能性の一覧がでてくる

# 続いて以下のように245をcallして 2Eat, 0Biteだった場合 11個に絞りこまれる
calc.input('245', 2, 0)
p calc.possibilities
# => ["240", "246", "247", "248", "249", "205", "265", "275", "285", "295", "345"]
```

Shuffle対応(ほとんどテストはしていない)

```ruby
calc = Numeron::Calculator.new
calc.input('123', 0, 3)
calc.shuffle # シャッフルされた
p calc.possibilities.size
# => 6

calc = Numeron::Calculator.new
calc.input('123', 1, 1)
p calc.possibilities.size
# => 42
calc.shuffle
p calc.possibilities.size
# => 126
```

以下の2つの変数を用いている

`@mays`

@mays[0]が左側の数値の可能性リスト(初期値0-9)<br>
@mays[1]が真ん中の数値の可能性リスト(初期値0-9)<br>
@mays[2]が右側の数値の可能性リスト(初期値0-9)<br>

`@possibilities`

解の可能性リスト

## Numeron::Analyzer

案がなかったので、以下3つの分析方法を適当に実装。<br>
計算量はまったく考慮していない

0e1bを最悪ケースとして、このケースが出た場合に、最も可能性リストが少なくなる数値を計算する機能

0e1b, 1e0bを最悪ケースとして、これらのケースが出た場合に、最も可能性リストの平均値が少なくなる数値を計算する機能

可能性リスト中から、最も可能性リストが少なくなる数値を計算する機能

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
